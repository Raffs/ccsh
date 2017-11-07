require 'rake'
require 'rspec/core/rake_task'

## Load the version from the gem module
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ccsh'

## ================================================
#  Start the rspec test
## ================================================
RSpec::Core::RakeTask.new(:test) do |task|
    task.pattern = Dir.glob('spec/**/*_spec.rb')
    task.rspec_opts = '--format documentation'
end

## ================================================
#  Running the gem building
## ================================================
desc "Building"
task :build do
    puts "Building the ccsh for #{CCSH::VERSION}"
    system "gem build ccsh.gemspec"
end

## ================================================
#  Publishing the generated gem into to gem
#  Rubygem repository. 
## ================================================
desc "Publishing gem file"
task :push do
    puts "Publishig"
    system "gem install ccsh-#{CCSH::VERSION}.gem"
end

task :default => :spec