require "./obj"

class Converter
  def initialize(@source, @destination)
    obj = OBJ.new File.new @source
    obj.parse { |objects| puts objects }
  end
end
