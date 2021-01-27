require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

def screen_test(file, method)
  raise ArgumentError, 'Missing argument: file' unless file
  require_relative 'tools/whirled_peas/tools/screen_tester'
  WhirledPeas::Tools::ScreenTester.new(file).send(method)
end

namespace :screen_test do
  %i[template view run save update debug].each do |t|
    task t, [:file] do |_, args|
      screen_test(args[:file], t)
    end
  end

  task :update_all do
    require_relative 'tools/whirled_peas/tools/screen_tester'
    WhirledPeas::Tools::ScreenTester.update_all
  end
end

task :screen_test do
  require_relative 'tools/whirled_peas/tools/screen_tester'
  WhirledPeas::Tools::ScreenTester.run_all
end

task default: :ci
task ci: %i[spec screen_test]
