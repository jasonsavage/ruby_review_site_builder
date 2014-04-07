#!/usr/bin/env ruby

require 'yaml'
require 'review_site_builder/runner'

module ReviewSiteBuilder
  
  VERSION     = "0.3.2"
  SUMMARY     = "Review Site Builder/Generator for images, links, and banner ads"
  DESCRIPTION = "Builds a website for a client to easily review each files listed in the *.yml config (optional)"
  
  def self.build! (base_path='./')
    
    #check for config.yml in current directory
    cnf_file = File.join(base_path, 'config.yml');
    #raise ArgumentError, 'config.yml was not found' unless File.exists? cnf_file
    
    #File.exists? load config.yml
    cnf = File.exists?(cnf_file) ? YAML::load_file( cnf_file ) : {}
    
    #run internal builder and return result
    return Runner.run!( base_path, cnf )
    
  end
  
end