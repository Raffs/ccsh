module CCSH
    module Utils

        ##
        # Responsible to merge the defaults settings with the each hosts
        # parameters.
        def self.merge_defaults(defaults)
            defaultsValues = {
                'user'          => 'root',
                'port'          => '22',
                'sudo_enabled'  => false,
                'sudo_password' => nil,
                'private_key'   => '~/.ssh/id_rsa',
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

        ##
        # Given an item, hash and wanted default return, return the
        # item if exists on array object or return the default
        # value if the key doesn't exist.
        def self.get_options(item, object, default)
            if object.key? item
                return object[item]
            end

            return default
        end

        ##
        # Pretty print the filtered hosts
        def self.display_hosts(hosts)
            puts "Selected Hosts (option: --show-hosts):"
            hosts.each do |host|
                puts "+ Server #{host.name}: #{host.user}@#{host.hostname} => Groups: #{host.groups}"
            end
            puts
        end

        ##
        # Display host display_hosts_verbosity
        def self.display_hosts_verbosity(hosts)
            hosts.each do |host|
                CCSH::Utils::verbose("sudo mode enable to host: #{host.hostname}") if host.sudo_enabled
            end
            puts
        end

        ##
        # Show at least 10 groups names
        def self.show_groups(hosts)
            hosts_groups = []
            hosts.each do |host|
                if host.groups != nil
                    host.groups.each do |gname|
                        hosts_groups.push(gname) unless hosts_groups.include?(gname)
                    end
                end
            end

            hosts_groups.slice(0, 10).each { |gname| puts "  - #{gname}" }
            puts "Example: ccsh #{hosts_groups[0]}" unless hosts_groups[0] == nil
            puts "Example: ccsh #{hosts_groups.slice(0,2).join(' ')}" unless hosts_groups.slice(0,2) == nil
        end

        ##
        # validate the ssh connection before start the ccsh console
        def self.valid_ssh(options)
            return true
        end

        ##
        # Display a message, if debug mode is enabled
        def self.debug(msg)
            puts "[DEBUG] #{msg}" if ENV['CCSH_DEBUG'] == "true"
        end

        ##
        # Verbosely display a message, if verbose mode is enabled
        def self.verbose(msg)
            puts "[verbose] #{msg}" if ENV['CCSH_VERBOSE'] == "true"
        end

        ##
        # Handle terminal signals
        def self.handle_signals
            Signal.trap('INT') do
                self.exit_console 0
            end

            Signal.trap('TERM') do
                self.exit_console 0
            end
        end

        ##
        # Exit the console message
        def self.exit_console(code, msg = nil)
            puts msg if msg != nil

            puts "\nBye..."
            exit code || 0
        end

        ##
        # clear the system console when run clear
        def self.clear_console
            printf "\e[H\e[2J"
        end

        ##
        # reset the console
        def self.reset_console
            printf("\033c");
        end
    end
end
