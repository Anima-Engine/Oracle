require "./block"

class Model < Block
  TYPE = 0

  def initialize(@vertices, @material)
    super()
  end

  def to_io(io)
    TYPE.to_io io, IO::ByteFormat::NetworkEndian
    @id.to_io io, IO::ByteFormat::NetworkEndian

    @vertices.id.to_io io, IO::ByteFormat::NetworkEndian
    @material.id.to_io io, IO::ByteFormat::NetworkEndian

    @vertices.to_io io
    @material.to_io io
  end
end
