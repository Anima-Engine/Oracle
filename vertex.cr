class Vertex
  getter :x, :y, :z, :u, :v

  def initialize(@x, @y, @z, @u, @v)
  end

  def to_io(io)
    @x.to_io io, IO::ByteFormat::NetworkEndian
    @y.to_io io, IO::ByteFormat::NetworkEndian
    @z.to_io io, IO::ByteFormat::NetworkEndian
    @u.to_io io, IO::ByteFormat::NetworkEndian
    @v.to_io io, IO::ByteFormat::NetworkEndian
  end
end
