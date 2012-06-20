# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nordea/file_transfer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Edgars Beigarts"]
  gem.email         = ["edgars.beigarts@makit.lv"]
  gem.summary       = "Ruby client for Nordea FileTransfer Web Services"
  gem.description   = gem.summary

  gem.files         = Dir.glob("lib/**/*") + %w(README.md LICENSE)
  gem.test_files    = Dir.glob("spec/**/*")
  gem.name          = "nordea-filetransfer"
  gem.require_paths = ["lib"]
  gem.version       = Nordea::FileTransfer::VERSION

  gem.add_development_dependency "rake", ">= 0.9.2.2"
  gem.add_development_dependency "rspec", "~> 2.10"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "vcr"
  gem.add_development_dependency "fakeweb"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "redcarpet"
  gem.add_development_dependency "awesome_print"
  gem.add_development_dependency "debugger"

  gem.add_runtime_dependency "activesupport", ">= 3.0"
  gem.add_runtime_dependency "savon", "~> 1.0.0"
  gem.add_runtime_dependency "virtus", "~> 0.5.1"
  gem.add_runtime_dependency "signer", "~> 1.1.0"
end
