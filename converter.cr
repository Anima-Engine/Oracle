require "./obj"
require "./blocks/model"
require "./blocks/compound_model"
require "./blocks/vertices"
require "./blocks/material"

class Converter
  def initialize(@source, @destination)
  end

  def open
    extension = File.extname @source

    if extension == ".obj"
      obj = OBJ.new File.new @source
      obj.parse
    else
      raise "Extention #{extension} not recognized."
    end
  end

  def write(objects)
    extension = File.extname @destination

    if extension == ".anm"
      file = File.new @destination, "w"

      if objects.size == 1
        vertices = Vertices.new objects[0][0].flatten
        material = objects[0][1]

        model = Model.new vertices, material
        model.to_io file
      else
        models = objects.map do |object|
          vertices = Vertices.new object[0].flatten
          material = object[1]

          Model.new vertices, material
        end

        compound_model = CompoundModel.new models
        compound_model.to_io file
      end

      file.close
    else
      raise "Extention #{extension} not recognized."
    end
  end

  def convert
    objects = open
    write objects
  end
end
