#!/usr/bin/env rake
require 'bundler/gem_tasks'

Bundler.setup

require 'rspec/mocks/version'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require File.expand_path('../spec/scenario/config/application', __FILE__)

Scenario::Application.load_tasks
