#!/usr/bin/env rake
require 'bundler/gem_tasks'

Bundler.setup

require 'rake'
require 'rake/rdoctask'
require 'rspec/mocks/version'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Default: run specs.'
task :default => :spec

desc 'Generate documentation for the devise_bushido_authenticatable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'devise_bushido_authenticatable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require File.expand_path('../spec/scenario/config/application', __FILE__)

Scenario::Application.load_tasks
