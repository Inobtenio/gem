require "bundler/gem_tasks"
# # require "rspec/core/rake_task"

# # RSpec::Core::RakeTask.new(:spec)
# require 'sshkit'
# require 'sshkit/sudo'
# include SSHKit::DSL
require_relative 'lib/color'
require_relative 'lib/gema'
require_relative 'lib/gema/modules/help'
require_relative 'lib/gema/modules/setup'
require_relative 'lib/gema/modules/install'
require_relative 'lib/gema/modules/deploy'
Dir.glob(Pathname.pwd.join('lib/gema/tasks/*.rake')).each { |r| load r}
# task default: [:help]
task :default => :spec
