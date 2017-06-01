class Help
  def self.suggest command=nil
    if command
      puts "The command #{command} was not recognized by Gema. See 'gema help'".orange
    else
      puts "TBD".orange
    end
  end
end