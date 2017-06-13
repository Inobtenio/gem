namespace :deploy do
  desc "Deploy app from scratch"
  task :create do
    Deploy.create
  end

  desc "Update an application that has already been deployed"
  task :update do
    Deploy.update
  end

  desc "Restore the application state to the last stable version"
  task :rollback do
    puts "deploy:rollback"
  end
end

namespace :test do
  task :some_test do
    puts "test:some_test"
  end 
end

task :install do
  desc "Generate configuration files and directories"
  Install.execute
end

task :help do
  desc "Help"
  puts "help:info"
end 