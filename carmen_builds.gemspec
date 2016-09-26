# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carmen_builds/version'

Gem::Specification.new do |spec|
  spec.name          = 'carmen_builds'
  spec.version       = CarmenBuilds::VERSION
  spec.authors       = ['Sichacvah']
  spec.email         = ['sichirc@gmail.com']

  spec.summary       = 'TODO: Write a short summary, because Rubygems requires one.'
  spec.description   = 'TODO: Write a longer description or delete this line.'
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'fastlane'
  spec.add_dependency 'match'
  spec.add_dependency 'pilot'
  spec.add_dependency 'gym'
  spec.add_dependency 'git'
  spec.add_dependency 'mini_magick'
  spec.add_dependency 'dotenv'
end
