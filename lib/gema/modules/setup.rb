require 'rails'
require 'awesome_print'
class Setup

	attr_accessor :app_name, :repo_url, :server_url, :user, :branch, :password, :deploy_to, :softlink_to, :linked_files, :keep_releases, :ruby_version, :rvm_gemset 
 	
	@@shared_instance = nil

	def self.init
		path = Pathname.new("config/gema").join("deploy.rb")
		path = Pathname.new(Gema.lib).join("generators/gema/templates/deploy.rb") unless path.exist?
		load(File.open(path))	
	end

	def initialize
		super
		yield self if block_given?
		@@shared_instance = self
	end

	def self.shared_instance
		init
		@@shared_instance
	end

end