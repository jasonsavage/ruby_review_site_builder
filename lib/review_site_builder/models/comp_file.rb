
module ReviewSiteBuilder
  
  class CompFile
      
      attr_reader :title, :path_src, :file_name, :second_file, :exists, :type, :width, :height, :body, :template
      attr_accessor :page_name, :prev_page, :next_page
      
      def initialize(src_path, file_name)
          
          #add support for polite and expandable banners (allow 2 swf to be specified)
          if file_name.include? '|' then
            name = file_name.split('|')
            file_name = name.shift 
            @second_file = CompFile.new(src_path, name.shift)
          end
  
          # generate a title to be used on the index page for this file
          @file_name  = File.basename(file_name)
          @ext        = File.extname(@file_name)
          @path_src   = File.join(src_path, file_name)
          @exists     = File.exists?(@path_src)
          
          @title      = get_file_title()
          @type       = get_file_type() 
          
          #puts @title
          #puts @file_name
          #puts @exists
          #puts @ext
          #puts @type
          
          #load haml template for this page
          @template = File.read( Paths::get_file('comp') )
          
          @width      = nil
          @height     = nil
          
          if @type == 'flash' && @exists then
            # get file width and height
            stream = File.open(@path_src, 'rb')
            @width, @height = SWF.dimensions(stream)
          end
          
          if @type == 'link' then
              @width = 1024
              @height = 768
          end
          
          # load haml template for this type of file
          template = File.read( Paths::get_file(@type) )
          haml_engine = Haml::Engine.new(template)
          @body = haml_engine.render( self )
      end
      
      # returns flash, image, link, na
      def get_file_type
          
          if @file_name.include? 'http' then
              return 'link'
          
          elsif ! @exists then
              return 'na'
  
          elsif @ext == '.swf'
              return 'flash'
              
          elsif @ext == '.jpg' || @ext == '.jpeg' || @ext == '.png' || @ext == '.gif'
              return 'image'
              
          else
              return 'na'
          end
      end
      
      def get_file_title
          name = File.basename(@file_name, @ext).gsub(/_/, " ").gsub(/([a-z])([A-Z])/, "\\1 \\2").split.map(&:capitalize).join(' ')
          return "#{name} (#{@ext})" + (@exists ? '' : " - missing")
      end
      
      def has_second_file?
          return @second_file != nil
      end
  end
end