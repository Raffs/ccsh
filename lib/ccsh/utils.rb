module CCSH
    module Utils
        def self.merge_defaults(defaults)
            defaultsValues = {
                'user'        => 'root',
                'port'        => '22',
                'private_key' => '~/.ssh/id_rsa',
            }
            defaultsValues.merge!(defaults) if defaults != nil

            ssh_options = {
                'timeout' => 720,
                'ssh-rsa' => 'ssh-rsa',
            }

            if defaults['ssh_options'] != nil
                defaultsValues['ssh_options'] = ssh_options.merge!(defaults['ssh_options'])
            else
                defaultsValues['ssh_options'] = ssh_options
            end

            return defaultsValues
        end

        def self.get_options(item, object, default)
            if object.key? item
                return object[item]
            end

            return default
        end

        def self.valid_ssh(options)
            return true
        end

        def self.debug(msg)
            puts "DEBUG", msg if ENV['CCSH_DEBUG'] == "true"
        end

        def self.verbose(msg)
            puts msg if ENV['CCSH_VERBOSE'] == "true"
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
            puts msg if msg != nil
    
            puts "\nBye..."
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