# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bwthomas/version'

Gem::Specification.new do |spec|
  spec.name          = "bwthomas"
  spec.version       = Bwthomas::VERSION
  spec.authors       = ["Blake Thomas"]
  spec.email         = ["bwthomas@gmail.com"]
  spec.description   = %q{TreeNode implementation}
  spec.summary       = %q{TreeNode implementation}

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "simplecov"
end
