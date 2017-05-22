require 'rake' unless defined? Rake
extend Rake::DSL

namespace :setup do
  task :check do
  	puts "setup:check"
  	Setup.shared_instance.verify
  end

  task :another_task do
  	puts "setup:another_task"
  end
end

task :setup do
	
end