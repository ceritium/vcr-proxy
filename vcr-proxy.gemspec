# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vcr/proxy/version'

Gem::Specification.new do |spec|
  spec.name          = 'vcr-proxy'
  spec.version       = VCR::Proxy::VERSION
  spec.authors       = ['José Galisteo']
  spec.email         = ['ceritium@gmail.com']

  spec.summary       = 'VCR web proxy'
  spec.description   = 'Web proxy based on Sinatra and VCR to record and replay all the http requests, useful for end to end tests.
'
  spec.homepage      = 'https://github.com/ceritium/vcr-proxy'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/ceritium/vcr-proxy'
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables << 'vcr-proxy'
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'vcr'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'webmock'
end
