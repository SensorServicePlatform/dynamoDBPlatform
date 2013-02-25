#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

task :environment => :disable_initializer

task :disable_initializer do
  ENV['DISABLE_INITIALIZER_FROM_RAKE'] = 'true'
end

CmuSds::Application.load_tasks
