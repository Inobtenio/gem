require 'rake' unless defined? Rake
extend Rake::DSL

namespace :install do
	task :go do
	  Install.execute
	end

	task :verify do
	  Gema.verify
	end
end