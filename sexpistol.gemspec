# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sexpistol/version'

Gem::Specification.new do |spec|
  spec.name          = 'sexpistol'
  spec.version       = Sexpistol::VERSION
  spec.authors       = ['Aaron Gough']
  spec.email         = ['aaron@aarongough.com']

  spec.summary       = 'Sexpistol is an easy-to-use S-Expression parser for Ruby. It is fast and has no dependencies.'
  spec.description   = 'Sexpistol is an easy-to-use S-Expression parser for Ruby. It is fast and has no dependencies.'
  spec.homepage      = 'https://github.com/aarongough/sexpistol'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
end
