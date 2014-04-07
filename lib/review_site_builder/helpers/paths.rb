
module ReviewSiteBuilder
    
    class Paths
        
        @@root_dir = File.dirname( __FILE__ )
        @@tmpl_dir = File.expand_path("../haml", @@root_dir)
        
        @@tmpl_files = {
            :index => 'index.haml',
            :comp  => 'comp.haml',
            :wrapper => 'wrapper.haml',
            
            :flash => "partials/flash.haml",
            :image => "partials/image.haml",
            :link  => "partials/link.haml",
            :na    => "partials/missing.haml"
        }
        
        @@tmpl_dirs = {
            :css   => 'css',
            :img  => 'img'
        }
        
        def self.get_root
            return @@root_path
        end
        
        def self.get_file( name )
            return File.join(@@tmpl_dir, @@tmpl_files[name.to_sym])
        end
        
        def self.get_dir( name )
            return File.join(@@tmpl_dir, @@tmpl_dirs[name.to_sym])
        end
    end

end