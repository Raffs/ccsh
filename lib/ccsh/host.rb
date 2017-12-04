module CCSH
    class Host        
        attr_accessor :name
        attr_accessor :port
        attr_accessor :user
        attr_accessor :groups
        attr_accessor :hostname
        attr_accessor :password
        attr_accessor :private_key
        attr_accessor :ssh_options
        attr_accessor :timeout

        def initialize
            @name = ''
            @port = 22
            @user = 'root'
            @groups = ''
            @hostname = '127.0.0.1'
            @password = nil
            @private_key = nil
            @ssh_options = []
        end

        def run(command)
            CCSH::Utils.verbose("Running command '#{@command}' on #{@hostname}")
            command = CCSH::SSH.start do |ssh|
                ssh.user = @user
                ssh.port = @port
                ssh.options = @ssh_options
                ssh.password = @password
                ssh.private_key = @private_key
                ssh.options = @ssh_options

                ssh.command = command
                ssh.hostname = @hostname || @name
            end

            return command
        end

        def contain?(target)
            return @groups.include? target
        end
    end
end