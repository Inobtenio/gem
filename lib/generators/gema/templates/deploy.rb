Setup.new do |setup|
#   Will be used to set the deploy_to directory and other configurations
  setup.app_name = "cimedic"

#   Repository from where checkout or pull will be done
  setup.repo_url = "git@github.com:Inobtenio/cimedic-rails.git"

#   Server where application will be deployed
  setup.server_url = "development.tektonlabs.com"

#   User to access the server
  setup.user = "ruby3k"

#   Password to grant access to the server. If not set, you will be prompted to enter it at deploy
  # setup.password = "my_password"

#   Defalt branch is master
  setup.branch = "development"

#   Default deploy_to directory is backends/my_app_name
  setup.deploy_to = "../backends"

#   Directory the app's public files will be soft linked to
  setup.softlink_to = "/var/www/backends"

#   Configuration files to be uploaded from your local machine
  setup.linked_files = ["application.yml", "setup_load_paths.rb"]

#   Default value for keep_releases is 5
  setup.keep_releases = 2

#   Especifies the version of ruby to be used
  setup.ruby_version = "2.3.0"

#   Gemset where gems will be installed
  setup.rvm_gemset = "cimedic"
end