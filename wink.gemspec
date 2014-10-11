# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wink/version'

Gem::Specification.new do |spec|
  spec.name          = "wink"
  spec.version       = Wink::VERSION
  spec.authors       = ["Garrett Bjerkhoel"]
  spec.email         = ["me@garrettbjerkhoel.com"]
  spec.summary       = %q{A Ruby wrapper for the Wink Hub API.}
  spec.homepage      = "https://github.com/dewski/wink"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable",         "~> 2.3"
  spec.add_dependency "faraday",             "~> 0.9"
  spec.add_dependency "faraday_middleware",  "~> 0.9"
  spec.add_dependency "multi_json",          "~> 1.10"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.0"
end
