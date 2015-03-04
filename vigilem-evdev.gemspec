# -*- encoding: utf-8 -*-
require './lib/vigilem/evdev/version'

Gem::Specification.new do |s|
  s.name          = 'vigilem-evdev'
  s.version       = Vigilem::Evdev::VERSION
  s.platform      = Gem::Platform::RUBY 
  s.summary       = 'Evdev bindings and DOM adapter for Vigilem'
  s.description   = 'Evdev bindings and DOM adapter for Vigilem'
  s.authors       = ['jtzero']
  s.email         = 'jtzero511@gmail'
  s.homepage      = 'http://rubygems.org/gems/vigilem-evdev'
  s.license       = 'MIT'
  
  s.extensions    = ['ext/Rakefile']
  
  s.add_dependency 'vigilem-core'
  s.add_dependency 'vigilem-dom'
  
  s.add_dependency 'vigilem-x11-stat'
  
  s.add_development_dependency 'yard'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'rspec-given'
  s.add_development_dependency 'turnip'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'RubyInline'
    
  s.files         = Dir['{lib,spec,ext,test,features,bin}/**/**'] + ['LICENSE.txt']
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
end
