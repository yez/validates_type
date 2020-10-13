lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require './version'

Gem::Specification.new do |s|
  s.name          = 'validates_type'
  s.version       = ValidatesType::VERSION
  s.summary       = %q{Type validation for ActiveModel/ActiveRecord attributes}
  s.description   = %q{This library helps validate attributes to specific types in the same way that ActiveModel valiations work. Able to chain additional modifiers to each validation.}
  s.authors       = ['Jake Yesbeck']
  s.email         = 'yesbeckjs@gmail.com'
  s.homepage      = 'http://rubygems.org/gems/validates_type'
  s.license       = 'MIT'

  s.require_paths = ['lib']
  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.grep(/^spec\//)

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'ruby-boolean', '~> 1.0'
  s.add_dependency 'activemodel', '~> 6.0'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '3.4'
  s.add_development_dependency 'activerecord', '>= 3.0.0'
  s.add_development_dependency 'sqlite3', '~> 1.3'
end
