module CCSH
    module Options
        require 'ostruct'
        require 'optparse'

        def self.parse_options(args)
            options = OpenStruct.new

            # default values
            user_home = File.expand_path('~')

            options.config      = "#{user_home}/.ccsh/config.yaml"
            options.hosts       = "#{user_home}/.ccsh/hosts.yaml"
            options.output      = ""
            options.debug       = false
            options.verbose     = false
            options.check       = false
            options.output      = nil
            options.show_hosts  = false
            options.max_threads = 0
            options.ask_pass    = false

            # open parser
            opt_parser = OptionParser.new do |opts|
                opts.banner = "Usage: ccsh [options] GROUP1 GROUP2 ... "
                opts.separator ""
                opts.separator "Options: "

                opts.on("-c", "--config CONFIG_FILE", "Configuration file (default: ~/.ccsh/config.yaml)") do |cfg|
                    options.config = cfg
                end

                opts.on("-d", "--[no-]debug", "Run Debug mode") do |d|
                    options.verbose = d
                    options.debug = d
                end

                opts.on("-h", "--hosts HOST_FILE", "Specified hosts file") do |h|
                    options.hosts = h
                end

                opts.on("-k", "--[no-]check", "Check host connection before continuing") do |k|
                    options.check = k
                end

                opts.on("-o", "--output FILEPATH", "Write all the interaction into an output file") do |out|
                    options.output = out
                end

                opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
                    options.show_hosts = v
                    options.verbose = v
                end

                opts.on("--show-hosts", "Output the filtered hosts") do |show_hosts|
                    options.show_hosts = show_hosts
                end

                opts.on("--ask-pass", "Ask password when using sudo") do |ask_pass|
                    options.ask_pass = ask_pass
                end

                opts.on("-t", "--max-threads MAX_THREADS",
                        "Define the maxinum number of threads (by default: the ammount of selected hosts)") do |max_threads|

                    begin
                        if not max_threads =~ /\d+/
                            raise "The value '#{max_threads}' is not a valid value to max_threads options"
                        end

                        max_threads = max_threads.to_i
                        if max_threads < 0
                            raise "max_threads value should be a positive number instead of '#{max_threads}'"
                        end

                        options.max_threads = max_threads
                    rescue Exception => e
                        raise e.message
                    end
                end

                opts.on("--version", "Display version") do |v|
                    puts "CCSH version #{CCSH::VERSION}"
                    exit
                end
            end
            opt_parser.parse!(args)

            options.targets = args
            return options
        end
    end
end
