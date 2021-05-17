# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "peach/version"

Gem::Specification.new do |s|
  s.name = 'peach'
  s.version = Peach::VERSION
  s.authors = ['Ben Hughes']
  s.email = 'ben@pixelmachine.org'
  s.summary = 'Parallel Each and other parallel things'
  s.homepage = 'https://github.com/schleyfox/peach'
  
  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency('rake')
  s.add_development_dependency('shoulda')
end
