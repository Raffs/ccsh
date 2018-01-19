require 'rubygems' unless defined?(Gem)

module CCSH
    require 'ccsh/version.rb'
    require 'ccsh/utils.rb'
    require 'ccsh/options.rb'
    require 'ccsh/host'
    require 'ccsh/hosts.rb'
    require 'ccsh/ssh.rb'

    def self.execute!
        options = CCSH::Options.parse_options ARGV

        ENV['CCSH_DEBUG']   = "true" if options[:debug]
        ENV['CCSH_VERBOSE'] = "true" if options[:verbose]

        raise "You must to specified a hostname or group" if options[:targets].empty?

        filename = options[:hosts]
        targets = options[:targets]

        hosts = CCSH::Hosts.new.parser!(filename).filter_by(targets)
        self.start_cli(hosts, options)
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
                puts "WARNING: ERROR: #{e.message}"
            end
        end
    end

    def self.start_cli(hosts, options)
        CCSH::Utils.display_hosts(hosts) if options[:show_hosts]

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
