class Block
  getter :id
  @@id = 0

  def initialize
    @id = Block.get_id
  end

  def self.get_id
    id = @@id

    @@id += 1

    id
  end
end
