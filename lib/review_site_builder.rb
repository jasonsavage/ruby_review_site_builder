
module ReviewSiteBuilder
  
  require 'gem/builder';
  require 'gem/comp_group';
  require 'gem/comp_file';
  
  class Publish
    
    def self.run! (config)
      
      puts "-------------------------------------------"
      puts "- ReviewSiteBuilder                       -"
      puts "- building site, please wait...           -"
      puts " "
      
      #TODO: change this to use a yml config file
      
      # need to figure out how to collect this info
      client   = config[:client]
      project  = config[:project]
      logo     = config[:logo]
      destination = File.absolute_path(config[:dest])
      
      groups = []
      config[:files].each do |obj|  
        
        # build groups
        g = CompGroup.new(obj[:group])
        obj[:comps].each do |path|
          
          g.comps << CompFile.new( path )

        end

        groups << g
 
      end
      
      # run builder
      Builder.build!(client, project, logo, groups, destination);
      
      # success - auto open destination
      puts "- complete                                -"
      puts "-------------------------------------------"
    end
    
  end
  
end