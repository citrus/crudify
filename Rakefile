require 'bundler'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << "lib" << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc "Default Task"
task :default => [ :test ]