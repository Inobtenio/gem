require 'net/ssh'
require 'net/ssh/shell'
require 'highline'

class Deploy

	@shared_instance = Setup.shared_instance
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
    	open_channel ssh
	    ssh.loop
  	end
	end

	def self.upload
		Net::SCP.start(@shared_instance.server_url, @shared_instance.user) do |scp|
			copy_files scp
		end
	end

	def self.open_channel ssh
		ssh.shell do |sh|
	    execute_command sh, command_list
    end
	  # channel.wait
	end

	def self.command_list mode=:create
		list = []
		puts @shared_instance.deploy_to
		@path  = Pathname.new(@shared_instance.deploy_to).join(@shared_instance.app_name)
		repo_name = @shared_instance.repo_url.split('/').last.chomp('.git')
		if mode == :create
			list << "cd #{@path.parent}"
			list << "git clone #{@shared_instance.repo_url}"
			list << "mv #{repo_name} #{@shared_instance.app_name}"
		end
		list << "cd #{@path}"
		list << "git checkout #{@shared_instance.branch}"
		list << "rvm use #{@shared_instance.ruby_version}@#{@shared_instance.rvm_gemset} --rvmrc --create"
		list << "rvm rvmrc trust #{@path}"
		@shared_instance.linked_files.each do |file|
			file_path = Pathname.new(@path).join("config/gema/#{file}")
			list << "cat << EOF >> " + file_path.to_s + "\n" + File.read(file_path) + "\nEOF" 
		end
		list << "bundle install"
		# list << "rake db:create db:migrate db:seed RAILS_ENV=production"
		# list << "rake assets:precompile RAILS_ENV=production"
		# list << "sudo ln -s #{@path}/public/ #{@shared_instance.soflink_location}/#{@shared_instance.app_name}"
		return list.join(';')
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
		# channel.request_pty do |ch, success|
		#   if success
		# 		channel.exec "bash -l; #{command}" do |ch, success|
		#       # raise "could not execute #{command}" unless success
		#       abort "could not execute #{command}" unless success

		#       # "on_data" is called when the process writes something to stdout
		#       ch.on_data do |c, data|
		#         if data =~ /sudo password: /
		#         	pass = @cli.ask("\nEnter your password:  ") { |q|	q.echo = false }
	 #        		ch.send_data("#{pass}\n")
		#         else
		#         	$stdout.print data.green
		#         end
		#       end

		#       # "on_extended_data" is called when the process writes something to stderr
		#       ch.on_extended_data do |c, type, data|
		#     		$stdout.print data.red
		#       end
		#     	# channel.on_close { puts "done!".blue }
		#     end
		#   else
		#     $stdout.print "could not obtain pty"
		#   end
		# end
		sh.execute command do |process|
      process.on_output do |c, data|
        if data =~ /sudo password: /
        	pass = @cli.ask("\nEnter your password:  ") { |q|	q.echo = false }
       		process.send_data("#{pass}\n")
        elsif data.include?("y[es]")
        	answer = @cli.ask("#{data}")
       		process.send_data("#{answer}\n")
        else
        	$stdout.print data.green
        end
      end

      # "on_extended_data" is called when the process writes something to stderr
      # process.on_stderr	 do |c, type, data|
    		# $stdout.print data.red
      # end
    	# channel.on_close { puts "done!".blue }
		end
	end
end