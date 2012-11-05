# -*- encoding: utf-8 -*-
require File.expand_path('../lib/monsove/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robson Mendonça"]
  gem.email         = ["robsonmwoc@gmail.com"]
  gem.description   = %q{Monsove provides an easy way to backup/restore your MongoDB databases to different storage engines using mongodump and mongorestore}
  gem.summary       = %q{Backup and Restore of MongoDB databases to external storage engines}
  gem.homepage      = "https://github.com/robsonmwoc/Monsove"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "monsove"
  gem.require_paths = ["lib"]
  gem.version       = Monsove::VERSION

  gem.add_dependency "thor"
  gem.add_dependency "fog", "~> 1.6.0"

  gem.add_development_dependency "rspec"
end