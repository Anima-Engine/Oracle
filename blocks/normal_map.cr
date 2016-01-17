require "./block"

class NormalMap < Block
  TYPE = 8

  def initialize(@path)
    super()
  end

  def to_io(io)
    TYPE.to_io io, IO::ByteFormat::NetworkEndian
    @id.to_io io, IO::ByteFormat::NetworkEndian

    @path.to_s io
    '\0'.to_s io
  end
end
