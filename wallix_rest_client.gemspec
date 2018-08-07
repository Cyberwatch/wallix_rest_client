lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wallix_rest_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'wallix_rest_client'
  spec.version       = WallixRestClient::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ['Maxime Alay-Eddine']
  spec.email         = ['maxime@cyberwatch.fr']

  spec.summary       = 'Provides a wrapper for the Wallix REST API.'
  spec.description   = 'Provides a wrapper for the Wallix Web Admin Bastion REST API.'
  spec.homepage      = 'https://github.com/cyberwatch/wallix_rest_client'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'addressable'
  spec.add_dependency 'json'
  spec.add_dependency 'openssl'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
