require 'rake'
require 'rspec/core/rake_task'

## Load the version from the gem module
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ccsh'

task :test do
    Rake::Task['test:spec'].invoke
end


task :spec do
    Rake::Task['test:spec'].invoke
end

## ================================================
#  Running the travis-ci
## ================================================
desc "building gem package"
task :travis do
    Rake::Task['test:spec'].invoke
end

## ================================================
#  Running the gem building
## ================================================
desc "building gem package"
task :build do
    system "gem build ccsh.gemspec"
end

## ================================================
#  Publishing the generated gem into to gem
#  Rubygem repository. 
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
