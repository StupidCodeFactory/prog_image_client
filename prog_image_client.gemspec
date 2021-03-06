lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "prog_image/version"

Gem::Specification.new do |spec|
  spec.name          = "prog_image_client"
  spec.version       = ProgImage::VERSION
  spec.authors       = ["yann marquet"]
  spec.email         = ["ymarquet@gmail.com"]

  spec.summary       = %q{Client library to interact with prog_image}
  spec.description   = %q{Client library to interact with prog_image, a high performance service to manage images}
  spec.homepage      = "https://github.com/StupidCodeFactory/prog_image_client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "connection_pool", "~> 2.2.2"
  spec.add_dependency "fastimage", "~> 2.1.3"
  spec.add_dependency "faraday", "~> 0.15.2"
  spec.add_dependency "faraday_middleware", "~> 0.12.2"
  spec.add_dependency "typhoeus", "~> 1.3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "vcr", "~> 4.0.0"
  spec.add_development_dependency "webmock", "~> 3.4.2"
  spec.add_development_dependency "pry"
end
