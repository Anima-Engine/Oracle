class Color
  getter :r, :g, :b

  def initialize(@r, @g, @b)
  end

  def to_io(io)
    @r.to_io io, IO::ByteFormat::NetworkEndian
    @g.to_io io, IO::ByteFormat::NetworkEndian
    @b.to_io io, IO::ByteFormat::NetworkEndian
  end
end
