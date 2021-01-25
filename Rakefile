require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

def screen_test(file, method)
  raise ArgumentError, 'Missing argument: file' unless file

  require 'bundler/setup'
  require 'whirled_peas'
  require_relative 'screen_test/screen_tester'

  WhirledPeas::ScreenTester.new(file).send(method)
end

namespace :screen_test do
  task :run, [:file] do |_, args|
    screen_test(args[:file], :run)
  end

  task :save_output, [:file] do |_, args|
    screen_test(args[:file], :save_output)
  end

  task :view, [:file] do |_, args|
    screen_test(args[:file], :view)
  end
end

task :screen_test do
  require 'bundler/setup'
  require 'whirled_peas'
  require_relative 'screen_test/screen_tester'

  WhirledPeas::ScreenTester.run_all
end

task default: [:screen_test, :spec]
