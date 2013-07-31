$: << File.expand_path('../lib', __FILE__)
require 'master_slave/version'

Gem::Specification.new do |gem|
  gem.name          = 'master_slave'
  gem.version       = MasterSlave::VERSION
  gem.authors       = 'Tumayun'
  gem.email         = 'tumayun.2010@gmail.com'
  gem.homepage      = 'https://github.com/tumayun/master_slave'
  gem.summary       = 'master_slave.'
  gem.description   = 'mysql separate read and write.'

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'rails', '>= 4.0.0'
end
