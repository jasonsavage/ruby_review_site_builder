
##
# Builder is used to load an publish review site html
##

require 'gem/template'
require 'fileutils'

class Builder 
  
  @@folders = {
    :css => "templates/css",
    :js => "templates/js"
  }
  @@templates = {
    :wrapper      => "templates/wrapper.html",
    :home         => "templates/index.html",
    :page         => "templates/comp.html",

    :flash        => "templates/includes/flash.html",
    :image        => "templates/includes/image.html",
    :missing      => "templates/includes/missing.html",
    :project_list => "templates/includes/project_list.html",
    :project_list_item => "templates/includes/list_item.html"
  }
  
  # creates a review site out of the supplied params
  def self.build!(client, project, logo, comp_groups, dest)
    
    update_paths;
    
    puts "- ::set current dir to #{dest}"
    FileUtils.cd(dest);
    
    # delete all old files
    Dir.foreach(dest) do |f|
      if f == '.' or f == '..' then 
        next
      elsif File.directory?(f) then 
          FileUtils.rm_rf(f)
      else 
        FileUtils.rm( f )
      end
    end
    puts "- ::removed all files in current dir"
    
    # create data dir
    FileUtils.mkdir 'data' unless Dir.exist?('data')
    puts "- ::created dir /data"
    
    # copy all css to @dest
    copy_folder_to_dest(@@folders[:css], 'css', dest);
    puts "- ::copied all css to /css"
    
    # copy all js to @dest
    copy_folder_to_dest(@@folders[:js], 'js', dest);
    puts "- ::copied all js to /js"
    
    has_logo = (logo != nil and logo.length > 0 && File.exists?(logo))
    if has_logo then
      # copy logo to img folder
      FileUtils.mkdir 'img' unless Dir.exist? 'img';
      FileUtils.cp_r(logo, "img")
      
      puts "- ::logo specifed"
      puts "- ::created dir and copied logo to /img"
    end
    
    # ---
    
    #create wrapper template
    tmp_wrapper = Template.new(@@templates[:wrapper]);
    tmp_wrapper.set_value("client", client);
    
    # generate comp pages
    # loop through each file and create a html page based on type swf/img
    i = 0
    comp_groups.each do |g|
      g.comps.each do |c|
        
        # copy comp to data dir
        begin
          FileUtils.cp_r(c.path, 'data')
          puts "- ::copied #{c.filename} to /data"
        rescue
          puts "- ::copy failed - file not found #{c.filename}"
        end
        
        # check comp for second path
        if c.has_second_path? then
          tmp = File.basename(c.second_path)
          #copy second banner to root folder
          begin
            FileUtils.cp_r(c.second_path, './')
            puts "- ::copied #{tmp} to /"
          rescue
            puts "- ::copy failed - file not found #{tmp}"
          end
        end
      
        # set comp paths
        c.new_path  = "comp_#{i}.html";

        # create comp tmpl
        if c.is_missing? then
          tmp_media = Template.new(@@templates[:missing])
          tmp_media.set_value("filename", c.path)
        elsif c.is_flash? then
          tmp_media = Template.new(@@templates[:flash])
          tmp_media.set_value("filename", "data/#{c.filename}")
          tmp_media.set_value("filewidth", c.width.to_s)
          tmp_media.set_value("fileheight", c.height.to_s)
        else
          tmp_media = Template.new(@@templates[:image])
          tmp_media.set_value("filename", "data/#{c.filename}")
        end

        tmp_page = Template.new(@@templates[:page])
        tmp_page.set_value("title", c.name)
        tmp_page.set_value("html", tmp_media.publish)

        # auto set previous and next links
        is_first = (i == 0)
        is_last = (comp_groups.last == g && g.comps.last == c)
        
        tmp_page.set_value("prevpage", is_first ? "index.html" : "comp_#{i-1}.html")
        tmp_page.set_value("nextpage", is_last  ? "index.html" : "comp_#{i+1}.html")
        
        # wrap comp html in the wrapper template
        tmp_wrapper.set_value("page_content", tmp_page.publish)

        # copy new html page to @dest as rename as comp_{n}.html
        save_html_to_dest(tmp_wrapper, File.join(dest, c.new_path))
        
        i+=1 # increment
        
        puts "- ::created /#{c.new_path}"
      end
    end

    # ---
    
    time = Time.new
    
    puts "- ::Building /index.html"
    
    # generate index page
    tmp_index_page = Template.new(@@templates[:home])
    tmp_index_page.set_value("client", client)
    tmp_index_page.set_value("project", project)
    tmp_index_page.set_value("date", time.month.to_s + "/" + time.day.to_s + "/" + time.year.to_s)
    tmp_index_page.set_value("logo", ""); # default is not to add logo
    
    if has_logo then
      tmp_logo = Template.new(@@templates[:image])
      tmp_logo.set_value("filename", "img/#{File.basename(logo)}") 
      tmp_index_page.set_value("logo", tmp_logo.publish);
    end
    
    tmp_proj_list = Template.new(@@templates[:project_list])
    html_proj_list = [];
    comp_groups.each do |group|
      
      puts "- ::building group #{group.title}"
      
      tmp_proj_list.set_value("title", group.title)
      html = [];
      # loop through each file and create a link on index page
      group.comps.each do |c|

        # create a template list item for comp
        tmp = Template.new(@@templates[:project_list_item])
        tmp.set_value("title", c.name )
        tmp.set_value("filename", c.new_path ) # new_path generated above
        
        puts "- ::->add link #{c.name} to #{c.new_path}"
        
        # publish string and collect in html array
        html << tmp.publish;
      end

      # set html token to generated value (string of il tags)
      tmp_proj_list.set_value('html', html.join);
      
      html_proj_list << tmp_proj_list.publish
      
    end
    
    # add project list html to index page
    tmp_index_page.set_value("html", html_proj_list.join)
    
    # wrap index html in the wrapper template
    tmp_wrapper.set_value("page_content", tmp_index_page.publish);
    
    # copy new html page to @dest
    save_html_to_dest(tmp_wrapper, File.join(dest, "index.html"));
    
    puts "- ::created /index.html"
    
    # ---
    
    # complete return success status
    return true;
    
  end
  
  # save the specified template to a destination
  def self.save_html_to_dest(tmpl, dest)
    
    File.open(dest, "w") do |io|
      io.write(tmpl.publish)
    end

  end
  
  # copies all the files from the specified folder to a new dest and folder name
  def self.copy_folder_to_dest(from, name, dest)
    
    FileUtils.cd(dest);
    
    puts "- ::created dir /#{name}"
    FileUtils.mkdir name unless Dir.exists? name
    FileUtils.cp_r(from, ".")
  end
  
  def self.update_paths
    
    root = File.dirname __FILE__
    
    @@folders.each do |k,v|
      @@folders[k] = File.join(root, v)
    end
    
    @@templates.each do |k,v|
      @@templates[k] = File.join(root, v)
    end
    
  end
  
end
