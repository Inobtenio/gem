require 'rails/generators'
module Gema
  class InstallGenerator < Rails::Generators::Base
    desc "Generate the deploy.rb file to setup your deployment"
    source_root File.expand_path('../templates', __FILE__)
   
    def copy_deploy_file
      puts "Creating files...".green
      template "deploy.rb", "config/gema/deploy.rb"
      puts "Done.".green
    end
  end
end