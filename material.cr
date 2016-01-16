class Material
  getter :ambient, :diffuse, :specular, :shininess, :texture, :normal_map

  def initialize(@ambient, @diffuse, @specular, @shininess, @texture, @normal_map)
  end
end

class Color
  getter :r, :g, :b

  def initialize(@r, @g, @b)
  end
end
