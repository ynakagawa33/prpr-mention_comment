# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prpr/mention_comment/version'

Gem::Specification.new do |spec|
  spec.name          = "prpr-mention_comment"
  spec.version       = Prpr::MentionComment::VERSION
  spec.authors       = ["mzp"]
  spec.email         = ["mzpppp@gmail.com"]

  spec.summary       = "Prpr plugin to notify mention comment to chat service."
  spec.description   = "When some comment containing mention is posted, the comment request is post to chat service, too."
  spec.homepage      = "https://github.com/mzp/prpr-mention_comment"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
