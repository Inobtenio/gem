namespace :help do
	task :info do
		puts "help:info"
	end	

	task :suggestion, [:command] do |t, args|
		puts args
		Gema::Help.suggest args[:command]
	end
end

task :help do
	puts "help"
end