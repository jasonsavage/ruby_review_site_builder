#!/usr/bin/env ruby

##
# Runner is used to load an publish review site html
##

require 'haml'
require 'fileutils'

require 'review_site_builder/models/comp_site'
require 'review_site_builder/models/comp_section'
require 'review_site_builder/models/comp_file'

require 'review_site_builder/helpers/swf'
require 'review_site_builder/helpers/paths'

module ReviewSiteBuilder
  
  class Runner 
    
    # creates a review site out of the supplied params
    def self.run!( base_path, config )
      
      # take config settings and parse them into the correct model for the Runner
      comp_site = CompSite.new( base_path, config )
    
      #switch file pointer to dest dir
      FileUtils.mkdir(comp_site.dest_path) unless Dir.exists?(comp_site.dest_path)
      FileUtils.cd( comp_site.dest_path );
      
      #clean out dest
      dir_cleanup();
      
      #move css dir to dest/css
      FileUtils.mkdir('css') unless Dir.exists?('css')
      FileUtils.cp_r( Paths::get_dir('css'), ".")
      
      #move img dir to dest/img
      FileUtils.mkdir('img') unless Dir.exists?('img')
      FileUtils.cp_r( Paths::get_dir('img'), ".")
      
      # create data dir
      FileUtils.mkdir 'data' unless Dir.exist?('data')
      
      #if logo - create /dest/img/ and copy logo to new location
      FileUtils.cp_r( comp_site.logo_path, 'img' ) unless comp_site.logo_path == nil
  
      #build out each comp review page
      page_index = 0 # global page number
      comp_site.sections.each do | sect |
          
          #loop through each comp in section and create an html page
          sect.comps.each do | comp |
              
              # set page links
              comp.page_name = "comp_#{page_index}.html"
              comp.prev_page = (page_index == 0) ? "index.html" : "comp_#{page_index-1}.html"
              comp.next_page = (comp_site.sections.last == sect && sect.comps.last == comp) ? "index.html" : "comp_#{page_index+1}.html"
          
              # save html to destination
              write_to_dest( comp, comp_site.dest_path )
              
              # copy asset file to destination
              if comp.exists then
                  FileUtils.cp_r( comp.path_src, 'data' )
              end
          
              if comp.has_second_file?
                  FileUtils.cp_r( comp.second_file.path_src, '.' )
              end
  
              # next page
              page_index += 1
          end
      end
      
      #build index page
      
      # save to destination
      write_to_dest( comp_site, comp_site.dest_path )
  
    end
    
    
    def self.dir_cleanup
      
      Dir.foreach('./') do |f|
          if f == '.' or f == '..' then 
              next
          elsif File.directory?(f) then 
              FileUtils.rm_rf(f)
          else 
              FileUtils.rm( f )
          end
      end
    end
    
    def self.write_to_dest( comp, dest )
      
      #load file 
      haml_engine = Haml::Engine.new( comp.template )
      page_content = haml_engine.render( comp )
      
      #load wrapper
      template = File.read( Paths::get_file('wrapper') )
      haml_engine = Haml::Engine.new(template)
      content = haml_engine.render( page_content )
          
      #save to dest
      File.open( File.join(dest, comp.page_name), "w") do |io|
          io.write( content )
      end
    end
    
  end
end
