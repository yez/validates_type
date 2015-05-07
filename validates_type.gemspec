lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require_relative './version'

Gem::Specification.new do |s|
  s.name          = 'validates_type'
  s.version       = ValidatesType::VERSION
  s.summary       = %q{Type validation for ActiveModel/ActiveRecord attributes}
  s.description   = %q{}
  s.authors       = ['Jake Yesbeck']
  s.email         = 'yesbeckjs@gmail.com'
  s.homepage      = 'http://rubygems.org/gems/validates_type'
  s.license       = 'MIT'

  s.require_paths = ['lib']
  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.grep(/^spec\//)

  s.add_dependency 'ruby-boolean', '>= 1.0.0'
  s.add_dependency 'activemodel', '>= 3.0.0'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'activerecord', '>= 3.0.0'
  s.add_development_dependency 'sqlite3'
end
