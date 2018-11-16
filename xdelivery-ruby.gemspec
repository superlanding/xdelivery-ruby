
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xdelivery/version"

Gem::Specification.new do |spec|
  spec.name          = "xdelivery"
  spec.version       = Xdelivery::VERSION
  spec.authors       = ["eddie"]
  spec.email         = ["eddie@super-landing.com"]

  spec.summary       = %q{火箭快遞 API 串接}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/superlanding/xdelivery-ruby"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency "rest-client"
end
