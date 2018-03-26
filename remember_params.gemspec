$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "remember_params/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "remember_params"
  s.version     = RememberParams::VERSION
  s.authors     = ["Johannes Treitz"]
  s.email       = ["jotreitz@gmail.com"]
  s.homepage    = "https://github.com/crispymtn/remember_params"
  s.summary     = "Rails gem that makes actions remember GET params like keywords and page."
  s.description = "Makes it easy to return to exact position on index pages after clicking on records."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0"
  s.add_development_dependency "timecop", "~> 0.8"
  s.add_development_dependency "pry"
end
