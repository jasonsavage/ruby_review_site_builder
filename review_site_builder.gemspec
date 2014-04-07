
$LOAD_PATH.push File.expand_path("lib", File.dirname(__FILE__))
require 'review_site_builder'

Gem::Specification.new do |s|
  s.name = 'review_site_builder'
  s.version     = ReviewSiteBuilder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.has_rdoc = false
  
  s.extra_rdoc_files = ['README.md', 'MIT-LICENSE.txt']
  s.summary     = ReviewSiteBuilder::SUMMARY
  s.description = ReviewSiteBuilder::DESCRIPTION
  
  s.author = 'Jason Savage'
  s.email = 'jason.savage2@gmail.com'
  
  s.executables = ['review_site_builder']

  s.files = Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end