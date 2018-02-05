require 'rubygems' unless defined?(Gem)

module CCSH
    require 'ccsh/version.rb'
    require 'ccsh/utils.rb'
    require 'ccsh/options.rb'
    require 'ccsh/host'
    require 'ccsh/hosts.rb'
    require 'ccsh/ssh.rb'

    def self.execute!
        begin
            options = CCSH::Options.parse_options ARGV

            ENV['CCSH_DEBUG']   = "true" if options[:debug]
            ENV['CCSH_VERBOSE'] = "true" if options[:verbose]

            if options[:targets].empty?
                error_msg = "You must specify a target hostname or group name."

                puts error_msg
                puts "Example:"
                puts "    'ccsh databases' - select all servers from the database group"
                puts "    'ccsh all'       - select all defined servers"
                puts "Please run 'ccsh --help' for details"
                puts ""

                raise error_msg
            end

            filename = options[:hosts]
            targets = options[:targets]
            hosts = CCSH::Hosts.new.parser!(filename).filter_by(targets)

            # validate and display pretty message if no hosts was found to the
            # given target.
            if hosts.empty?
                error_msg = "Could not found any hosts that matches the given target(s): '#{targets.join(', ')}'"
                puts error_msg

                puts "Here are some groups found on the file: '#{filename}'"
                CCSH::Utils.show_groups(CCSH::Hosts.new.parser!(filename).filter_by('all'))

                puts ""
                raise error_msg
            end

            self.start_cli(hosts, options)

        rescue Exception => e
            if not e.message == 'exit'
                CCSH::Utils.debug "Backtrace:\n\t#{e.backtrace.join("\n\t")}\n\n"
                CCSH::Utils.verbose "Backtrace:\n\t#{e.backtrace.join("\n\t")}\n\n"

                STDERR.puts "An error occur and system exit with the following message: "
                STDERR.puts "  #{e.message}"

                exit!
            end

            exit
        end
    end

    def self.with_info(options)
        cmd_start = Time.now
        cmd = yield
        cmd_end = Time.now

        info = {
            'rc'   => cmd.return_code,
            'time' => cmd_end - cmd_start,
        }.inspect

        prompt = ">>> #{cmd.hostname} #{info}"

        puts prompt
        STDERR.puts cmd.stderr if cmd.stderr != nil && cmd.stderr != ''
        puts cmd.stdout if cmd.stdout != nil && cmd.stdout != ''
        puts

        if options[:output] != nil
            begin
                file_handler = File.new(options[:output], "a+")

                file_handler.write("#{prompt}\n")
                file_handler.write("ERROR: #{cmd.stderr}") if cmd.stderr != nil && cmd.stderr != ''
                file_handler.write("#{cmd.stdout}\n") if cmd.stdout != nil && cmd.stdout != ''
            rescue Exception => e
                puts "WARNING: An error occur when trying to write the output to file: #{options[:output]}. "
                puts "WARNING: Thefore, the output is not being stored"
                puts "WARNING: Error message: #{e.message}"
            end
        end
    end


    def self.start_cli(hosts, options)
        CCSH::Utils.display_hosts(hosts) if options[:show_hosts]
        CCSH::Utils.display_hosts_verbosity(hosts) if options[:verbose]

        quit = false
        loop do
            begin
                CCSH::Utils.handle_signals
                printf "ccsh> "
                command = STDIN.gets.chomp

                if command != ''
                    CCSH::Utils.exit_console 0 if command == 'quit'
                    CCSH::Utils.exit_console 0 if command == 'exit'

                    if command == 'clear'
                        CCSH::Utils.clear_console
                    elsif command == 'reset'
                        CCSH::Utils.reset_console
                    else
                        if ((options.max_threads == 0) || (options.max_threads > hosts.length))
                            options.max_threads = hosts.length
                        end

                        CCSH::Utils.debug "Using #{options.max_threads} maximum of threads"

                        hosts.each_slice(options.max_threads) do |batch_hosts|
                            threads = []

                            batch_hosts.each do |host|
                                if command =~ /^(.*)+sudo/
                                    if host.sudo_enabled != true
                                        msg = "WARN: You cannot run sudo on the host #{host.hostname}, please enable sudo mode for this hosts"
                                        CCSH::Utils.verbose(msg)
                                        next
                                    end

                                    if host.sudo_password == nil
                                        if options[:ask_pass]
                                            printf "[#{host.hostname}] Enter sudo password for #{host.user}: "
                                            passwd = STDIN.noecho(&:gets).chomp

                                            host.sudo_password = passwd
                                        else
                                            error_msg = """
                                                [#{host.hostname}] sudo password was not provided use (--ask-pass) to ask the sudo password
                                            """

                                            raise error_msg.gsub!(/\s+/, ' ')
                                        end
                                    end
                                end

                                threads << Thread.new do
                                    info = with_info(options) do
                                        host.run command
                                    end
                                end
                            end

                            threads.each(&:join)
                        end
                    end
                end
            rescue Exception => exception
                STDERR.puts exception.message
                STDERR.puts
                raise exception
            end
        end
    end
end
