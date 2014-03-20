
require 'gem/swf'

class CompFile
  
  attr_reader :name, :filename, :ext, :path, :width, :height, :second_path
  attr_accessor :new_path
  
  def initialize(path)
    
    #add support for polite and expandable banners (allow 2 swf to be specified)
    if path.include? '|' then
      tmp = path.split('|')
      path = tmp.shift 
      
      @second_path = File.absolute_path( File.join(File.dirname(path), tmp) )
    end
          
    @path     = File.absolute_path(path)
    @filename = File.basename(@path)
    @ext      = File.extname(@path)
    @name     = File.basename(@path, @ext).gsub(/_/, " ")
    @missing  = !File.exists?(@path)
    
    if @missing then 
      @name += " (missing)" 
    end
    
    if is_flash? && !@missing then
      # get file width and height
      stream = File.open(@path, 'rb')
      @width, @height = SWF.dimensions(stream)
    end
    
  end
  
  def is_flash?
    return (@ext == ".swf")
  end
  
  def is_missing?
    return @missing
  end
  
  def has_second_path?
    return @second_path != nil
  end
end