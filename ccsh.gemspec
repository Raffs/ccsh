lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ccsh/version'

Gem::Specification.new do |s|
    s.name        = 'ccsh'
    s.version     = CCSH::VERSION
    s.date        = '2017-11-03'
    s.summary     = 'Interactive multiple client shell command'
    s.description = 'Interactive shell console, connected into multiple clients'
    s.authors     = ['Rafael Silva <raffs>']
    s.email       = ['rafaeloliveira.cs@gmail.com']
    s.homepage    = 'https://github.com/raffs/ccsh'
    s.license     = 'Apache-2.0'

    s.files       = Dir['bin/*'] +
                    Dir['lib/**/*.rb']
    s.executables = s.files.grep(%r{^bin/ccsh}) { |f| File.basename(f) }

    s.required_ruby_version = "~> 2.0"

    # system dependencies
    s.add_dependency "net-ssh", "~> 4.2"

    # load development dependecies
    s.add_development_dependency "bundler", "~> 1.16"
    s.add_development_dependency "rake", "~> 10.0"
    s.add_development_dependency "rspec", "~> 3.0"
end
