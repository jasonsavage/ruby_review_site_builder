

module ReviewSiteBuilder
    
  class CompSection
      
      attr_reader :title, :dir, :comps
      
      def initialize(src_path, cnf=nil)
          
          if cnf == nil then cnf = {} end
          
          #title config key (optional) default is nil (no section title)
          @title  = cnf.has_key?('title') ? cnf['title'] : 'Project Files'
          
          #dir config key (optional) default is nil (src_path)
          @dir    = cnf.has_key?('dir') ? File.join(src_path, cnf['dir']) : src_path
          
          @comps = []
          
          #comps config key (optional) default is empty array
          if cnf.has_key?('comps')
              
              cnf['comps'].each do |c|
                  # create a new comp file for each item in the array
                  @comps << CompFile.new( @dir, c )
                  
              end
          end
      end
      
      def add_compfile( obj )
          @comps << CompFile.new( @dir, obj )
      end
      
  end
  
end
