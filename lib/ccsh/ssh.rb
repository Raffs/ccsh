module CCSH
    module SSH
        require 'net/ssh'

        def self.start
            cmd = RemoteCommand.new
            yield cmd

            raise 'Could not parser the remote command' if cmd.command == nil
            raise 'Could not parser the hostname' if cmd.hostname == nil

            return cmd.execute!
        end

        class RemoteCommand
            attr_accessor :command
            attr_accessor :hostname
            attr_accessor :options
            attr_accessor :user
            attr_accessor :port
            attr_accessor :password
            attr_accessor :private_key
            attr_accessor :options

            attr_accessor :stdout
            attr_accessor :stderr
            attr_accessor :return_code
            attr_accessor :return_signal

            def initialize
                @command  = nil
                @hostname = nil
                @options  = []
                @stdout = ''
                @stderr = ''
            end

            def execute!
                @options = {
                    :password => @password,
                    :keys     => [@private_key],
                    :port     => @port,
                    :host_key => @options['host_key'],
                    :timeout  => @options['timeout'],
                }.select {|key,value| value != nil}

                raise "something" unless CCSH::Utils.valid_ssh(@options)

                Net::SSH.start(@hostname, @user, @options) do |ssh|
                    ssh.open_channel do |ch|
                        ch.exec @command do |ch, success|
                            raise "Could execute command #{command} on #{host}" unless success
                        end

                        ch.on_data do |c, data|
                            @stdout << data
                        end

                        ch.on_extended_data do |c, type, data|
                            @stderr << data
                        end

                        ch.on_request("exit-status") do |c,data|
                            @return_code = data.read_long
                        end
                    
                        ch.on_request("exit-signal") do |c, data|
                            @return_signal = data.read_long
                        end

                    end.wait    
                end

                return self
            end
        end
    end
end