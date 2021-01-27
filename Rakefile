require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :screen_test do
  require_relative 'tools/whirled_peas/tools/screen_tester'
  WhirledPeas::Tools::ScreenTester.run_all
end

task ci: %i[spec screen_test]
task default: :ci
