# encoding: utf-8
require File.expand_path('../lib/omniauth-redux/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'faraday', '~> 0.7.5'
  gem.add_dependency 'bbc_redux', '~> 0.3.4'

  gem.add_development_dependency 'yard'

  gem.authors = ['James Harrison']
  gem.email = ['james.harrison2@bbc.co.uk']
  gem.description = %q{A BBC Redux authentication module for OmniAuth based off the HTTP Basic module.}
  gem.summary = gem.description
  gem.homepage = 'http://github.com/JamesHarrison/omniauth-redux'

  gem.name = 'omniauth-redux'
  gem.require_paths = ['lib']
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = OmniAuth::Redux::VERSION
end
