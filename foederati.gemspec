# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'foederati/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'foederati'
  s.version     = Foederati::VERSION
  s.authors     = ['Richard Doe']
  s.email       = ['richard.doe@rwdit.net']
  s.summary     = 'Federated search'
  s.homepage    = 'https://github.com/europeana/foederati'
  s.license     = 'EUPL-1.1'

  s.files = Dir['{lib,spec}/**/*', 'LICENSE.md', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop', '0.39.0' # only update when Hound does
  s.add_development_dependency 'rspec', '~> 3.5'
end
