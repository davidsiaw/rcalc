# frozen_string_literal: true

require_relative 'lib/rcalc/version'

Gem::Specification.new do |spec|
  spec.name          = 'rcalc'
  spec.version       = Rcalc::VERSION
  spec.authors       = ['David Siaw']
  spec.email         = ['874280+davidsiaw@users.noreply.github.com']

  spec.summary       = 'Ruby Calculator'
  spec.description   = 'Terminal tools for interactive calculations'
  spec.homepage      = 'https://github.com/davidsiaw/rcalc'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/davidsiaw/rcalc'
  spec.metadata['changelog_uri'] = 'https://github.com/davidsiaw/rcalc'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['{exe,data,lib}/**/*'] + %w[Gemfile rcalc.gemspec]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
end
