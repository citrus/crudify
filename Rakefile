require 'bundler'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.verbose = true
end


desc "Default Task"
task :default => [ :test ]

