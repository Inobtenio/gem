Setup.new do |setup|
#		Will be used to set the deploy_to directory and other configurations
  setup.app_name = "my_app_name"

#   Repository from where checkout or pull will be done
  setup.repo_url = "git@example.com:me/my_repo.git"

#   Server where application will be deployed
  setup.server_url = "my_example_server.com"

#   User to access the server
  setup.user = "root"

#   Password to grant access to the server. If not set, you will be prompted to enter it at deploy
  setup.password = "rU.by3k3k2017"

# 	Defalt branch is master
  setup.branch = "master"

# 	Default deploy_to directory is backends/my_app_name
  setup.deploy_to = "../home/backends"

#   XXXXXXXXXX
  setup.soflink_location = "/var/www/backends"

#		Configuration files to be uploaded from your local machine
  setup.linked_files = "config/application.yml"

# 	Default value for keep_releases is 5
  setup.keep_releases = 2

#		Especifies the version of ruby to be used
  setup.ruby_version = "2.1.1"

#		Gemset where gems will be installed
  setup.rvm_gemset = "test_gemset"
end