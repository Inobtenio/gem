# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gema/version"

Gem::Specification.new do |spec|
  spec.name          = "gema"
  spec.version       = Gema::VERSION
  spec.authors       = ["Kevin Martin"]
  spec.email         = ["knmartinm@gmail.com"]
  spec.summary       = %q{A simple gem.}
  spec.description   = %q{A simple gem.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.require_paths = ["lib"]

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  spec.add_runtime_dependency 'net-ssh'
  spec.add_runtime_dependency 'net-ssh-shell'
  spec.add_runtime_dependency 'net-scp'
  spec.add_runtime_dependency 'sshkit', '~> 1.10'
  spec.add_runtime_dependency 'sshkit-sudo', '~> 0.1.0'
  spec.add_runtime_dependency 'awesome_print'
  spec.add_runtime_dependency 'highline', '~> 1.7', '>= 1.7.8'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
