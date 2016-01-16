require "./obj"

class Converter
  def initialize(@source, @destination)
    obj = OBJ.new File.new @source
    obj.parse { |triangles, material| puts [triangles, material] }
  end
end
