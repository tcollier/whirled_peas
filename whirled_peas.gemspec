require_relative 'lib/whirled_peas/version'

Gem::Specification.new do |spec|
  spec.name          = 'whirled_peas'
  spec.version       = WhirledPeas::VERSION
  spec.authors       = ['Tom Collier']
  spec.email         = ['tcollier@gmail.com']

  spec.summary       = %q{Visualizer for Advent of Code solutions}
  spec.homepage      = 'https://github.com/tcollier/whirled_peas'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/tcollier/whirled_peas/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'highline', '~> 2.0'
  spec.add_runtime_dependency 'json', '~> 2.5'
  spec.add_runtime_dependency 'tty-cursor', '~> 0.7'
end
