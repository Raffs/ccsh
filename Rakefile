require 'rake'
require 'rspec/core/rake_task'

## Load the version from the gem module
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ccsh'

## ================================================
#  Alias to run tests
## ================================================
task :test   { Rake::Task['test:spec'].invoke }
task :spec   { Rake::Task['test:spec'].invoke }
task :travis { Rake::Task['test:spec'].invoke }

## ================================================
#  Publishing the generated gem into to gem
#  Rubygem repository. 
## ================================================
desc "Deploy gem locally"
task :deploy_local do
    Rake::Task['build'].invoke
    Rake::Task['install_local'].invoke
end

## ================================================
#  Running the gem building
## ================================================
desc "building gem package"
task :build do
    system "gem build ccsh.gemspec"
end

## ================================================
#  Install the builded gem locally
## ================================================
desc "Install local"
task :install_local do
    system "gem install ccsh-#{CCSH::VERSION}.gem"
end

namespace :test do

    ## ================================================
    #  Start the rspec test
    ## ================================================
    RSpec::Core::RakeTask.new(:spec) do |task|
        task.pattern = Dir.glob('spec/**/*_spec.rb')
        task.rspec_opts = '--format documentation'
    end
end

task :default => :spec
