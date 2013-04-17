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
  spec.homepage      = "http://github.com/khellan/hbasegate"
  spec.license       = "MIT"

  spec.files         = %w(README.md
                          lib/commons-configuration-1.6.jar
                          lib/commons-lang-2.5.jar
                          lib/commons-logging-1.1.1.jar
                          lib/guava-11.0.2.jar
                          lib/hadoop-auth.jar
                          lib/hadoop-common.jar
                          lib/hbase.jar
                          lib/hbasegate.rb
                          lib/log4j-1.2.17.jar
                          lib/slf4j-api-1.6.1.jar
                          lib/zookeeper-3.4.5.jar
                          lib/hbasegate/hbase_configuration.rb
                          lib/hbasegate/htable.rb
                          lib/hbasegate/result.rb
                          lib/hbasegate/version.rb
)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
end
