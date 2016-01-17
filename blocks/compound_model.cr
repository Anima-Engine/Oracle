require "./block"

class CompoundModel < Block
  TYPE = 1

  def initialize(@models)
    super()
  end

  def to_io(io)
    TYPE.to_io io, IO::ByteFormat::NetworkEndian
    @id.to_io io, IO::ByteFormat::NetworkEndian

    @models.size.to_io io, IO::ByteFormat::NetworkEndian
    @models.each { |model| model.id.to_io io, IO::ByteFormat::NetworkEndian }

    @models.each &.to_io(io)
  end
end
