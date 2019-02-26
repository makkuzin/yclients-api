lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yclients/api/version"

Gem::Specification.new do |spec|
  spec.name          = "yclients-api"
  spec.version       = Yclients::Api::VERSION
  spec.authors       = ["Maksim Akkuzin"]
  spec.email         = ["maksim.akkuzin@yandex.ru"]

  spec.summary       = %q{Yclients API}
  spec.description   = %q{Ruby interface to the Yclients API}
  spec.homepage      = "https://github.com/makkuzin/yclients-api"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
