$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rss_chanel/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rss_chanel"
  s.version     = RssChanel::VERSION
  s.authors     = ["zanovski"]
  s.email       = ["aleksandrz335@gmail.com"]
  s.homepage    = "https://github.com/zanovski/rss"
  s.summary     = "Summary of RssChanel."
  s.description = "Description of RssChanel."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"

  s.add_development_dependency "sqlite3"
end
