require 'rake' unless defined? Rake
extend Rake::DSL

namespace	:test do
	task :some_test do
		puts "test:some_test"
	end	
end