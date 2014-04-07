
module ReviewSiteBuilder
    
    class CompSite
            
        attr_reader :client_name, :project_name, :logo_path, :dest_path, :src_path, :sections, :template, :date, :page_name
      
        def initialize(base_path, cnf={})
            
            # convert to absolute path
            base_path = File.absolute_path(base_path)
            
            #client config key (optional) default is nil (no client name)
            @client_name    = cnf.has_key?('client') ? cnf['client'] : nil
        
            #project config key (optional) default is nil (no project name)
            @project_name   = cnf.has_key?('project') ? cnf['project'] : nil
        
            #dest config key (optional) default is ./build
            @dest_path      = cnf.has_key?('dest') ? File.join(base_path, cnf['dest']) : File.join(base_path, 'build')
        
            #src config key (optional) default is ./src
            @src_path       = cnf.has_key?('src') ? File.join(base_path, cnf['src']) : File.join(base_path, 'src')
            
            #logo config key (optional) default is nil (no logo)
            @logo_path      = cnf.has_key?('logo') ? File.join(base_path, cnf['logo']) : nil
            
            time        = Time.new
            @date       = time.month.to_s + "/" + time.day.to_s + "/" + time.year.to_s
            
            @page_name = 'index.html'
            
            #load haml template for this page
            @template = File.read( Paths::get_file('index') )
            
            #files config key (optional) default is all files found in the src_path or an empty array
            @sections = []
            global_sect = nil #obj to collect any items not in a section
            
            if ! cnf.has_key?('files') then
                cnf['files'] = Dir.glob(@src_path + '/**/*.*').collect do |file|
                    file.sub(@src_path + '/','')
                end
            end
            
            # loop through each item in the array and create a section for it
            cnf['files'].each do |obj|  
    
                sect = nil
            
                # check if the item is an object or a string
                if obj.is_a? Hash then
              
                    #create a Comp Section out of the hash
                    sect = CompSection.new(@src_path, obj)
              
                elsif obj.is_a? String then
              
                    #lazy create the global section
                    if global_sect == nil then 
                        global_sect = CompSection.new(@src_path) 
                    end
              
                    #create a Comp out of the string obj and add it to the global group
                    global_sect.add_compfile( obj )
              
                #else who knows what was found so ignore  
                end
            
                # if a group was created, add it to the files array
                unless sect == nil then 
                    @sections << sect
                end
                
            end
      
            # if a global group was created, add it to the files array
            unless global_sect == nil then 
                @sections << global_sect
            end
    
        end
    
    end

end
