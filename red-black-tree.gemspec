# frozen_string_literal: true

require_relative "lib/red_black_tree/version"

Gem::Specification.new do |spec|
  spec.name = "red-black-tree"
  spec.version = RedBlackTree::VERSION
  spec.authors = ["Joshua Young"]
  spec.email = ["djry1999@gmail.com"]

  spec.summary = "Red-Black Tree Data Structure for Ruby"
  spec.homepage = "https://github.com/joshuay03/red-black-tree"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://joshuay03.github.io/red-black-tree/"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir["{lib}/**/*", "**/*.{gemspec,md,txt}"]
  spec.require_paths = ["lib"]
end
