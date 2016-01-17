require "./block"

class Vertices < Block
  getter :vertices
  TYPE = 5

  def initialize(@vertices)
    super()
  end

  def to_io(io)
    TYPE.to_io io, IO::ByteFormat::NetworkEndian
    @id.to_io io, IO::ByteFormat::NetworkEndian
    (@vertices.size * 5).to_io io, IO::ByteFormat::NetworkEndian

    @vertices.each { |vertex| vertex.to_io io }
  end
end
