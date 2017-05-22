require 'rake' unless defined? Rake
extend Rake::DSL

namespace :deploy do
	task :create do
		Deploy.create
	end

	task :test => "setup:check" do
		Deploy.connect
	end
	task :update do
		puts "deploy:update"
	end

	task :rollback do
		puts "deploy:rollback"
	end
end