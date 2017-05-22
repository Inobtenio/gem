require 'erb'	
class Install < Gema
 
 	def self.execute full=false
	  puts "Creating files...".green
 		config_dir = Pathname.new("config").join("gema")
	  deploy_yml = File.expand_path("../../templates/deploy.rb", __FILE__)

	  Rake.mkdir_p config_dir
	  puts "config/deploy directory created.".green

	  entries = [{ template: deploy_yml, file: config_dir.join("deploy.rb") }]

	  entries.each do |entry|
      File.open(entry[:file], "w+") do |f|
        f.write(ERB.new(File.read(entry[:template])).result(binding))
        puts "deploy file written.".green
      end
	  end
  	puts "Done.".green
 	end

end