$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dateable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dateable"
  s.version     = Dateable::VERSION
  s.authors     = ["Michael Glass"]
  s.email       = ["michael.glass@gmail.com"]
  s.homepage    = "http://github.com/1000memories"
  s.summary     = "Allows versatile storing of dates as strings and other formats in ActiveRecord Models"
  s.description = <<-EOF
    Dates can be stored as DateTime objects or as Strings.  Dates stored as 
    Strings are parsed into native DateTimes, and a specificity ranking (day, 
    month, year, several_years, decade) is also saved.  Dates can be retrievd 
    either in DateTime or String format.
  EOF

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails",   "~> 3.1.0"
  s.add_dependency "chronic", "~> 0.6.4"

  s.add_runtime_dependency "activerecord"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "jnunemaker-matchy"
end
