# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dmg/version"

Gem::Specification.new do |s|
  s.name        = "dmg"
  s.version     = Dmg::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Philippe Creux"]
  s.email       = ["pcreux@gmail.com"]
  s.homepage    = "https://github.com/versapay/dmg"
  s.summary     = %q{Install popular applications provided as dmgs from the command line}
  s.description = %q{It's like apt-get for Mac}

  s.default_executable = %q{dmg}

  s.add_dependency 'thor', '>= 0.14.6'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
