namespace :deploy do
	task :create do
		Deploy.create
	end

	task :test => "setup:check" do
		Deploy.connect
	end
	task :update do
		Deploy.connect :update
	end

	task :rollback do
		puts "deploy:rollback"
	end
end

namespace :help do
	task :info do
		puts "help:info"
	end	

	task :suggestion, [:command] do |t, args|
		puts args
		Help.suggest args[:command]
	end
end

namespace :install do
	task :go do
	  Install.execute
	end

	task :verify do
	  Gema.verify
	end
end

namespace :setup do
  task :check do
  	puts "setup:check"
  	Setup.shared_instance.verify
  end

  task :another_task do
  	puts "setup:another_task"
  end
end

namespace	:test do
	task :some_test do
		puts "test:some_test"
	end	
end