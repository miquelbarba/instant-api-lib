# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'instant_api/version'

Gem::Specification.new do |s|
  s.name        = "instant-api"
  s.summary     = "Automatically creates a REST API"
  s.description = "Automatically creates a REST API for Rails projects"
  s.authors     = ['Miquel Barba']
  s.email       = 'miquel.barba@gmail.com'
  s.homepage    = 'https://github.com/miquelbarba/instant-api'
  s.files       = `git ls-files`.split("\n")
  s.version     = InstantApi::VERSION
  s.require_paths = ['lib']
  s.license     = 'MIT'

  s.add_runtime_dependency 'kaminari', '~> 0.15'
  s.add_runtime_dependency 'rails-api', '~> 0.2'
  s.add_runtime_dependency 'rails', '~> 4.0'
end
