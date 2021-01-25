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
  %i[debug run save view].each do |t|
    task t, [:file] do |_, args|
      screen_test(args[:file], t)
    end
  end

  task :update_all do
    require 'bundler/setup'
    require 'whirled_peas'
    require_relative 'screen_test/screen_tester'

    WhirledPeas::ScreenTester.update_all
  end
end

task :screen_test do
  require 'bundler/setup'
  require 'whirled_peas'
  require_relative 'screen_test/screen_tester'

  WhirledPeas::ScreenTester.run_all
end

task default: [:screen_test, :spec]
