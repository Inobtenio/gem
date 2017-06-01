require 'erb'
require 'rails'
class Install
 
  def self.execute full=false
    puts "Creating files...".green
    puts "Rails.root"
    config_dir = Gema.config
    deploy_yml = File.expand_path("../../templates/deploy.rb", __FILE__)

    Rake.mkdir_p config_dir
    puts "config/gema directory created.".green

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