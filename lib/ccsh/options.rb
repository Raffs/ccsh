module CCSH
    module Options
        require 'ostruct'
        require 'optparse'
    
        def self.parse_options(args)
            options = OpenStruct.new
    
            # default values
            options.config  = "~/ccsh/"
            options.hosts   = '~/.ccsh/hosts.yaml'
            options.output  = ""
            options.debug   = false
            options.verbose = false
            options.check   = false
    
            # open parser
            opt_parser = OptionParser.new do |opts|
                opts.banner = "Usage: ccsh [options] GROUP1 GROUP2 ... "
                opts.separator ""
                opts.separator "Options: "
    
                opts.on("-c", "--config CONFIG_FILE", "Configuration file (default: ~/ccsh/default/yaml)") do |cfg|
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

                opts.on("-m", "--max-threads", "Define the max threads limits (default: total host number)") do |max|
                    options.max_threads = max
                end

                opts.on("-o", "--output FILEPATH",
                        "Save the output on specific file, rather then the default log system") do |out|
                    options.output = out
                end

                opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
                    options.verbose = v
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