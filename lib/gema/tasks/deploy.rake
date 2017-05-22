namespace :deploy do
	task :create do
		Gema::Deploy.create
	end

	task :test => "setup:check" do
		Gema::Deploy.connect
	end
	task :update do
		puts "deploy:update"
	end

	task :rollback do
		puts "deploy:rollback"
	end
end