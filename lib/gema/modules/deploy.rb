require 'net/ssh'
require 'net/ssh/shell'
require 'highline'
require 'gema/modules/setup'
require 'yaml'
require 'erb'

class Deploy

	@shared_instance = Setup.shared_instance
	@apache_sites_path = "/etc/apache2/sites-enabled/"
	@cli = HighLine.new
	@path = nil

	def self.create
		connect :create
	end

	def self.update
		connect :update
	end

	private

	def self.connect mode
		Net::SSH.start(@shared_instance.server_url, @shared_instance.user) do |ssh|
	    # open a new channel and configure a minimal set of callbacks, then run
	    # the event loop until the channel finishes (closes)
    	open_channel ssh, mode
	    ssh.loop
  	end
	end

	### Method for uploading files via SCP. Not used because of not finding a way of using it
	### without creating new connections for every file or mix it with SSH so data can be
	### transfered through that protocol.

	# def self.upload
	# 	Net::SCP.start(@shared_instance.server_url, @shared_instance.user) do |scp|
	# 		copy_files scp
	# 	end
	# end

	def self.open_channel ssh, mode
		ssh.shell do |sh|
	    execute_command sh, command_list(mode)
    end
	end

	def self.command_list mode=:create
		@path  = Pathname.new(@shared_instance.deploy_to).join(@shared_instance.app_name)
		commands = send("#{mode.to_s}_list").push(echo(nil, "Deployment complete.", nil))
		return commands.join(';')
	end

	def self.create_list
		repo_name = @shared_instance.repo_url.split('/').last.chomp('.git')
		return [
							cd(@path.parent),
							git("clone", nil, @shared_instance.repo_url),
							mv(repo_name, @shared_instance.app_name),
							cd(@path),
							git("checkout", @shared_instance.branch, nil),
							git("pull", "origin", @shared_instance.branch),
							rvm("create", "#{@shared_instance.ruby_version}@#{@shared_instance.rvm_gemset}", nil),
							rvm("trust", nil, @path),
							copy_files_commands,
							spring,
							gem,
							bundle,
							rake("db", "migrate"),
							rake("db", "seed"),
							rake("assets", "precompile"),
							"sudo ln -s #{@path}/public/ #{@shared_instance.softlink_to}/#{@shared_instance.app_name}",
							create_tmp_script_file,
							"sudo #{chown(@shared_instance.user, @apache_sites_path)}",
							bash("add_location", ERB.new(File.read(Gema.lib.join('generators/gema/templates/add_location_to_virtualhost.erb'))).result(binding), "#{@apache_sites_path}001-default"),
							"sudo #{chown(@shared_instance.user, @apache_sites_path)}",
							rm("add_location.sh"),
							"sudo /etc/init.d/apache2 reload"
						]
	end

	def self.update_list
		return [
							cd(@path),
							git("pull", "origin", @shared_instance.branch),
							rvm("use", "#{@shared_instance.ruby_version}@#{@shared_instance.rvm_gemset}", nil),
							bundle,
							rake("db", "migrate"),
							rake("assets", "precompile"),
							"touch tmp/restart.txt"
						]
	end

	def self.execute_command_list channel, list
		list.each do |command|
			execute_command channel, command
		end
	end

	def self.copy_files scp
		@shared_instance.linked_files.each do |file|
			scp.upload! Pathname.new("config/gema/#{file}"), Pathname.new("#{@path}")
		end
	end

	def self.execute_command sh, command
		sh.execute command do |process|
      process.on_output do |c, data|
        if data.include?("password") || data.include?("Password")
        	pass = @cli.ask("\nEnter your password:  ".green) { |q|	q.echo = "*" }
       		process.send_data("#{pass}\n")
        elsif data.include?("y[es]")
        	answer = @cli.ask("#{data}")
       		process.send_data("#{answer}\n")
       	elsif data.include?("Deployment complete")
       		@cli.say(data.orange)
       		sh.close!
        else
        	$stdout.print data.green
        end
      end
		end
	end

	def self.copy_files_commands
		list = []
		@shared_instance.linked_files.each do |file|
			file_origin_path = Gema.config.join("#{file}")
			file_destination_path = Gema.app_config.join("#{file}")
			if file.ends_with? ".rb"
				list << echo("-e", "'#{File.read(file_origin_path)}'", file_destination_path.to_s)
			else
				list << echo("-e", "'#{YAML.load(File.open(file_origin_path)).to_yaml}'", file_destination_path.to_s)
			end
		end
		return list
	end

	def self.read_script_file
		File.read(Gema.lib.join('gema/scripts/add_location'))
	end

	def self.create_tmp_script_file
		[echo("-e", "'#{read_script_file}'", "./add_location.sh")]
	end

	private

	def self.cd path
		"cd #{path}"
	end

	def self.git action, branch, remote
		"git #{action} #{branch} #{remote}"
	end

	def self.mv origin, destiny
		"mv #{origin} #{destiny}"
	end

	def self.echo option, content, path
		path.present? ? "echo #{option} #{content} > #{path}" : "echo #{option} #{content}"
	end

	def self.chown user, path
		"chown #{user}: #{path}"
	end

	def self.rvm action, gemset, path
		if action == "use"
			"rvm use #{gemset}"
		elsif action == "create"
			"rvm use #{gemset} --rvmrc --create"
		elsif action == "trust"
			"rvm rvmrc trust #{path}"
		else
			""
		end
	end

	def self.spring action="stop"
		"spring #{action}"
	end

	def self.gem action="install", name="bundler"
		"gem #{action} #{name}" 
	end

	def self.bundle action="install"
		"bundle #{action}"
	end

	def self.rake namespace, action
		"rake #{namespace}:#{action} RAILS_ENV=production"
	end

	def self.bash script_name, first, second
		". #{@path.join(script_name)}.sh '#{first}' #{second}"
	end

	def self.rm path
		"rm #{path}"
	end
end