desc 'Run rspec'
task :spec => :bundle_install do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(-fs -c)
  end
end

task :default => :spec

desc 'Install all gem dependencies'
task :bundle_install do
  sh 'bundle install'
end

desc 'Build the gem'
task :build do
  sh 'gem build *.gemspec'
end

desc 'Install the gem'
task :install => :build do
  sh 'gem install *.gem'
  sh 'rm *.gem'
end