require 'bundler'

Bundler.setup

require 'rake'
require 'rake/rdoctask'
require 'rspec/mocks/version'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Default: run specs.'
task :default => :spec

desc 'Generate documentation for the devise_cas_authenticatable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'devise_cas_authenticatable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "devise_cas_authenticatable"
    gemspec.summary = "CAS authentication module for Devise"
    gemspec.description = "CAS authentication module for Devise"
    gemspec.email = "natbudin@gmail.com"
    gemspec.homepage = "http://github.com/nbudin/devise_cas_authenticatable"
    gemspec.authors = ["Nat Budin"]
    gemspec.add_runtime_dependency "devise", ">= 1.0.6"
    gemspec.add_runtime_dependency "rubycas-client", ">= 2.2.1"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

namespace :scenario do
  require File.expand_path('../spec/scenario/config/application', __FILE__)

  Scenario::Application.load_tasks
end
