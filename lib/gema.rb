require "gema/version"
require "color"

module Gema
	def self.root
    Pathname.new(File.expand_path('../..', __FILE__))
  end

  def self.bin
    Pathname.new(File.join(root, 'bin'))
  end

  def self.lib
    Pathname.new(File.join(root, 'lib'))
  end

  def self.config
    Pathname.new("config/gema")
  end

  def self.app_config
    Pathname.new("config")
  end
  # Your code goes here...
end

require "gema/modules/deploy"
require "gema/modules/help"
require "gema/modules/info"
require "gema/modules/install"
require "gema/modules/setup"
require "gema/railtie" if defined?(Rails)
