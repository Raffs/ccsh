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
            attr_accessor :enable_sudo
            attr_accessor :sudo_password

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

                @enable_sudo      = false
                @sudo_user        = 'root'
                @sudo_password    = nil
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
                        ch.on_data do |c, data|

                            if data =~ /^\[sudo\] password for /

                                if @enable_sudo
                                    if @sudo_password != nil
                                        ch.send_data "#{@sudo_password}\n"
                                    else
                                        msg = """The server #{@hostname} asked for user password
                                            by the 'password' or 'sudo_password' option was not defined.
                                        """.gsub("\n", ' ').squeeze(' ')

                                        STDERR.puts "[WARN] #{msg}"
                                        ch.send_data "\x03"
                                    end
                                else
                                    msg = """The server #{@hostname} asked for user password
                                        the sudo_enabled option was not allowed
                                        skipping this hosts setup
                                    """.gsub("\n", ' ').squeeze(' ')

                                    STDERR.puts "[WARN] #{msg}"
                                    ch.send_data "\x03"
                                end
                            else
                                @stdout << data
                            end
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

                        ch.request_pty do |ch, success|
                            if success
                                CCSH::Utils.debug("pty successfully obtained for #{@hostname}")
                            else
                                CCSH::Utils.debug("pty unsuccessfully obtained for #{@hostname}")
                            end
                        end

                        ch.exec @command do |ch, success|
                            raise "Could execute command #{command} on #{host}" unless success
                        end
                    end.wait
                end

                return self
            end
        end
    end
end
