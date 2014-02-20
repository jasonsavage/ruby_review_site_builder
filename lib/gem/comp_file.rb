
require 'gem/swf'

class CompFile
  
  attr_reader :name, :filename, :ext, :path, :width, :height
  attr_accessor :new_path
  
  def initialize(path)
    
    @path     = path
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
 
end