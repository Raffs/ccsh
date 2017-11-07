module CCSH
    require 'yaml'
    require 'pathname'

    require 'ccsh/host'

    class Hosts
        attr_accessor :defaults
        attr_accessor :hosts

        def initialize
            # TODO
        end

        def parser!(filename)
            begin
                file = Pathname.new(filename)

                raise "The file does not exists: '#{file.realpath}'" if not file.exist?
                raise "The host file is not regular file: '#{file.realpath}'" if not file.file?

                hostfile = YAML.load_file(file.realpath)

                @defaults = hostfile['defaults']
                @hosts = []

                hostfile['hosts'].each do |h|
                    host = Host.new

                    host.name = CCSH::Utils.get_options('name', h, @defaults['name'])                    
                    host.user = CCSH::Utils.get_options('user', h, @defaults['user'])
                    host.port = CCSH::Utils.get_options('port', h, @defaults['port'])

                    host.hostname = CCSH::Utils.get_options('hostname', h, @defaults['hostname'])
                    host.password = CCSH::Utils.get_options('password', h, @defaults['password'])
                    host.private_key = CCSH::Utils.get_options('private_key', h, @defaults['private_key'])
                    host.ssh_options = CCSH::Utils.get_options('ssh_options', h, @defaults['ssh_options'])
                    host.timeout = CCSH::Utils.get_options('timeout', h, @defaults['timeout'])

                    host.groups = h['groups']

                    @hosts << host
                end
            rescue Exception => e
                puts e.message
                puts e.backtrace
                puts
            end

            return self
        end

        def filter_by(targets)
            return @hosts if targets.include? 'all'

            hosts = []
            @hosts.each do |host|
                targets.each do |target|
                    hosts << host if host.groups.include? target
                end
            end

            return hosts
        end
    end
end