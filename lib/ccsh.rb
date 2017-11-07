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
                        system('reset')
                    else
                        hosts.each do |host|
                            r = host.run command
                            return_code = "rc: #{r.return_code}" if r.return_code != nil

                            puts ">>> #{r.hostname} [#{return_code}]"
                            puts r.stderr if r.stderr != nil && r.stderr != ''
                            puts r.stdout if r.stdout != nil && r.stdout != ''
                            puts
                        end
                    end
                end
            rescue Exception => exception
                puts exception.message
                puts
                raise exception
            end
        end
    end
end