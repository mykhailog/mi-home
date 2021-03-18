# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mi_home/version'

Gem::Specification.new do |spec|
  spec.name          = 'mi-home'
  spec.version       = MiHome::VERSION
  spec.authors       = ['Mykhailo Goloborodko']
  spec.email         = ['mykhailo.goloborodko@gmail.com']

  spec.summary       = %q{Ruby API for interacting with Xiaomi Mi Home sensors and devices.}
  spec.description   = %q{Ruby API for interacting with Xiaomi Mi Home sensors and devices.}
  spec.homepage      = "https://github.com/mykhailog/mi-home"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'unobservable'
  spec.add_dependency 'activesupport'
end
