# -*- encoding: utf-8 -*-
require File.expand_path('../lib/truthtable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tanaka Akira"]
  gem.email         = ["akr@fsij.org"]
  gem.description   = "The truthtable library generates a truth table from a logical formula written in Ruby.
                       The truth table can be converted to a logical formula.
                       DNF, CNF and Quine-McCluskey supported."
  gem.summary       = "Generate truthtable from logical formula"
  gem.homepage      = "http://rubygems.org/gems/truthtable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "truthtable"
  gem.require_paths = ["lib"]
  gem.version       = Truthtable::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "gem-release"
  gem.add_dependency "msgpack"
end
