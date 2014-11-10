$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "angular_rails_seo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "angular_rails_seo"
  s.version     = AngularRailsSeo::VERSION
  s.authors     = ["Matt Ellis"]
  s.email       = ["m.ellis27@gmail.com"]
  s.homepage    = "http://sudoseng.com"
  s.summary     = "Provides a unified strategy for SEO between Rails and AngularJS."
  s.description = "This gem provides a way to share SEO data between Rails and AngularJS, without having to replicate data. It requires use of the asset pipeline."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_runtime_dependency 'rails', '>= 3.0.0'
end
