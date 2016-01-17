require "./block"

class Material < Block
  getter :ambient, :diffuse, :specular, :shininess, :texture, :normal_map
  TYPE = 6

  def initialize(@ambient, @diffuse, @specular, @shininess, @texture, @normal_map)
    super()
  end

  def to_io(io)
    TYPE.to_io io, IO::ByteFormat::NetworkEndian
    @id.to_io io, IO::ByteFormat::NetworkEndian

    @ambient.to_io io
    @diffuse.to_io io
    @specular.to_io io

    @shininess.to_io io, IO::ByteFormat::NetworkEndian

    @texture.id.to_io io, IO::ByteFormat::NetworkEndian
    @normal_map.id.to_io io, IO::ByteFormat::NetworkEndian

    @texture.to_io io
    @normal_map.to_io io
  end
end
