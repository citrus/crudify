# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crudify/version"

Gem::Specification.new do |s|
  s.name        = "crudify"
  s.version     = Crudify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Spencer Steffen"]
  s.email       = ["spencer@citrusme.com"]
  s.homepage    = "http://github.com/citrus/crudify"
  
  s.summary     = %q{Crudify is a dynamic resource controller for Rails 3.}
  s.description = %q{Crudify is a dynamic resource controller for Rails 3. The goal is to have very skinny controllers with powerful hooks to easily customize.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('rails',         '>= 3.0.0')
	s.add_dependency('will_paginate', '>= 2.3.15')
  s.add_dependency('meta_search',   '>= 1.0.1')
  
	s.add_development_dependency('shoulda', '>= 2.11.3')
	s.add_development_dependency('sqlite3-ruby', '>= 1.3.3')
	s.add_development_dependency('capybara', '>= 0.4.1')
	s.add_development_dependency('selenium-webdriver', '>= 0.1.3')
	
end