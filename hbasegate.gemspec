# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hbasegate/version'

Gem::Specification.new do |spec|
  spec.name          = "hbasegate"
  spec.version       = HBaseGate::VERSION
  spec.authors       = ["Knut O. Hellan"]
  spec.email         = ["knut.hellan@gmail.com"]
  spec.description   = %q{JRuby gem wrapping Java API for HBase}
  spec.summary       = %q{More ruby friendly API than using Java directly}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
end
