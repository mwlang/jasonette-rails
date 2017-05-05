$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jasonette/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jasonette-rails"
  s.version     = Jasonette::VERSION
  s.authors     = ["mwlang"]
  s.email       = ["mwlang@cybrains.net"]
  s.homepage    = "http://codeconnoisseur.org"
  s.summary     = "Jbuilder bolt-on to make Jasonette JSON easier to produce"
  s.description = "Jbuilder bolt-on to make Jasonette JSON easier to produce"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails",         ">= 4.0.0"
  s.add_dependency "multi_json",    "~> 1.2"
  # s.add_dependency "actionview",    ">= 4.0.0"

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "guard-rspec"

  s.add_development_dependency "rspec", "~> 3.5.0"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-its", "~> 1.2.0"
  s.add_development_dependency "pry-byebug", "~> 3.4.0"
  s.add_development_dependency "json_matchers", "~> 0.7.0"
  s.add_development_dependency "sqlite3"
end
