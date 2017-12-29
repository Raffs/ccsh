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

        self.start_cli CCSH::Hosts.new.parser!(filename).filter_by(targets)
    end

    def self.with_info
        cmd_start = Time.now
        cmd = yield
        cmd_end = Time.now

        info = {
            'rc'   => cmd.return_code,
            'time' => cmd_end - cmd_start,
        }.inspect

        puts ">>> #{cmd.hostname} #{info}"
        STDERR.puts cmd.stderr if cmd.stderr != nil && cmd.stderr != ''
        puts cmd.stdout if cmd.stdout != nil && cmd.stdout != ''
        puts
    end

    def self.start_cli(hosts)
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
                        threads = []
                        hosts.each do |host|
                            threads << Thread.new do

                                with_info do
                                    host.run command
                                end
                            end
                        end

                        threads.each(&:join)
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
