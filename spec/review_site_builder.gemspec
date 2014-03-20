Gem::Specification.new do |s|
  s.name = 'review_site_builder'
  s.version = '0.0.2'
  s.has_rdoc = true
  #s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'Use to generate a basic review site for images and flash banners'
  s.description = s.summary
  s.author = 'Jason Savage'
  s.email = 'jason.savage2@gmail.com'
  # s.executables = ['your_executable_here']
  # s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.files = Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end