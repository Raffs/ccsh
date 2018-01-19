module CCSH
    module Options
        require 'ostruct'
        require 'optparse'

        def self.parse_options(args)
            options = OpenStruct.new

            # default values
            user_home = File.expand_path('~')

            options.config     = "#{user_home}/.ccsh/config.yaml"
            options.hosts      = "#{user_home}/.ccsh/hosts.yaml"
            options.output     = ""
            options.debug      = false
            options.verbose    = false
            options.check      = false
            options.output     = nil
            options.show_hosts = false

            # open parser
            opt_parser = OptionParser.new do |opts|
                opts.banner = "Usage: ccsh [options] GROUP1 GROUP2 ... "
                opts.separator ""
                opts.separator "Options: "

                opts.on("-c", "--config CONFIG_FILE", "Configuration file (default: ~/.ccsh/config.yaml)") do |cfg|
                    options.config = cfg
                end

                opts.on("-d", "--[no-]debug", "Run Debug mode") do |d|
                    options.debug = d
                end

                opts.on("-h", "--hosts HOST_FILE", "Specified hosts file") do |h|
                    options.hosts = h
                end

                opts.on("-k", "--[no-]check", "Check host connection before continuing") do |k|
                    options.check = k
                end

                opts.on("-o", "--output FILEPATH", "Write the interaction into a file") do |out|
                    options.output = out
                end

                opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
                    options.verbose = v
                end

                opts.on("--show-hosts", "Output the filtered hosts") do |show_hosts|
                    options.show_hosts = show_hosts
                end

                opts.on("--version", "Display version") do |v|
                    build = "build #{CCSH::BUILD_NUMBER}" if CCSH::BUILD_NUMBER != nil
                    puts "CCSH version #{CCSH::VERSION} #{build}"
                    exit
                end
            end
            opt_parser.parse!(args)

            options.targets = args
            return options
        end
    end
end
