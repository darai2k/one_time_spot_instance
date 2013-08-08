# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'one_time_spot_instance/version'

Gem::Specification.new do |spec|
  spec.name          = "one_time_spot_instance"
  spec.version       = OneTimeSpotInstance::VERSION
  spec.authors       = ["Daichi Arai"]
  spec.email         = ["daichi2k@gmail.com"]
  spec.description   = %q{Use AWS Spot Instance}
  spec.summary       = %q{Use AWS Spot Instance}
  spec.homepage      = "https://github.com/darai2k/one_time_spot_instance"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "aws-sdk", "~> 1.0"
  spec.add_runtime_dependency "activesupport", "~> 4.0"
end
