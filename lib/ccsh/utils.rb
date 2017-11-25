module CCSH
    module Utils

        def self.get_options(item, object, default)
            if object.key? item
                return object[item]
            end

            return default
        end

        def self.debug(msg)
            STDOUT.puts "DEBUG", msg if ENV['CCSH_DEBUG'] == "true"
        end

        def self.verbose(msg)
            STDOUT.puts msg if ENV['CCSH_VERBOSE'] == "true"
        end

        def self.handle_signals
            Signal.trap('INT') do
                self.exit_console 0
            end
    
            Signal.trap('TERM') do
                self.exit_console 0
            end
        end

        def self.exit_console(code, msg = nil)
            STDOUT.puts msg if msg != nil
    
            STDOUT.puts "\nBye..."
            exit code || 0
        end
    
        def self.clear_console
            printf "\e[H\e[2J"
        end

        def self.clear_console
            printf("\033c");
        end
    end
end