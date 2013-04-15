
##
# Template is a model like class for publishing html files
##

class Template
  
  def initialize(path)
    
    @path = path;
    @tokens = {};
    
  end
  
  def set_value(key, value)
    
    @tokens[key.to_sym] = value;
    
  end
  
  def publish
    
    # load template from path in a string
    io = File.open(@path, "r")
    html = io.read();

    # loop through tokens and populate html template string
    
    @tokens.each do |sym, value|
      
      pattern = "${" + sym.to_s + "}"
      html.gsub!(pattern, value)
      
    end

    # return generated html as a string
    return html
  end
  
end