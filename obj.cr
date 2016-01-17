require "./vertex"
require "./blocks/material"
require "./blocks/texture"
require "./blocks/normal_map"
require "./color"

class OBJ
  def initialize(@file)
  end

  def parse
    positions = [] of { Float32, Float32, Float32 }
    coordinates = [] of { Float32, Float32 }
    faces = [] of { { Int32, Int32 }, { Int32, Int32 }, { Int32, Int32 } }

    objects = {} of String => Array(Array(Vertex))
    materials = {} of String => Material
    name = nil

    @file.each_line do |line|
      if line =~ /^mtllib\s/
        filename = line.split.last
        path = @file.path.gsub /\/[^\/]*$/, ""

        ambient = nil
        diffuse = nil
        specular = nil
        shininess = nil
        texture = nil
        normal_map = nil

        File.each_line "#{path}/#{filename}" do |line|
          if line =~ /^newmtl\s/
            if name != nil
              if ambient == nil
                raise "Ambient data missing in #{filename}. (Ka)"
              elsif diffuse == nil
                raise "Diffuse data missing in #{filename}. (Kd)"
              elsif specular == nil
                raise "Specular data missing in #{filename}. (Ks)"
              elsif shininess == nil
                raise "Shininess data missing in #{filename}. (Ns)"
              elsif texture == nil
                raise "Texture path missing in #{filename}. (map_Kd)"
              elsif normal_map == nil
                raise "Normal map path missing in #{filename}. (map_Bump)"
              else
                materials[name as String] = Material.new(
                  ambient as Color,
                  diffuse as Color,
                  specular as Color,
                  shininess as Float32,
                  texture as Texture,
                  normal_map as NormalMap
                )
              end
            end

            name = line.split.last
          elsif line =~ /^Ka\s/
            tokens = line.split

            ambient = Color.new tokens[-3].to_f32, tokens[-2].to_f32, tokens[-1].to_f32
          elsif line =~ /^Kd\s/
            tokens = line.split

            diffuse = Color.new tokens[-3].to_f32, tokens[-2].to_f32, tokens[-1].to_f32
          elsif line =~ /^Ks\s/
            tokens = line.split

            specular = Color.new tokens[-3].to_f32, tokens[-2].to_f32, tokens[-1].to_f32
          elsif line =~ /^Ns\s/
            shininess = line.split.last.to_f32
          elsif line =~ /^map_Kd\s/
            texture = Texture.new line.split.last
          elsif line =~ /^map_Bump\s/
            normal_map = NormalMap.new line.split.last
          end
        end

        if ambient == nil
          raise "Ambient data missing in #{filename}. (Ka)"
        elsif diffuse == nil
          raise "Diffuse data missing in #{filename}. (Kd)"
        elsif specular == nil
          raise "Specular data missing in #{filename}. (Ks)"
        elsif shininess == nil
          raise "Shininess data missing in #{filename}. (Ns)"
        elsif texture == nil
          raise "Texture path missing in #{filename}. (map_Kd)"
        elsif normal_map == nil
          raise "Normal map path missing in #{filename}. (map_Bump)"
        else
          materials[name as String] = Material.new(
            ambient as Color,
            diffuse as Color,
            specular as Color,
            shininess as Float32,
            texture as Texture,
            normal_map as NormalMap
          )

          name = nil
        end
      elsif line =~ /^usemtl\s/
        if name != nil
          triangles = faces.map do |face|
            (0..2).map do |i|
              Vertex.new(
                positions[face[i][0] - 1][0],
                positions[face[i][0] - 1][1],
                positions[face[i][0] - 1][2],
                coordinates[face[i][1] - 1][0],
                coordinates[face[i][1] - 1][1],
              )
            end
          end

          objects[name as String] = triangles

          faces.clear
        end

        name = line.split.last
      elsif line =~ /^v\s/
        tokens = line.split

        positions << { tokens[-3].to_f32, tokens[-2].to_f32, tokens[-1].to_f32 }
      elsif line =~ /^vt\s/
        tokens = line.split

        coordinates << { tokens[-2].to_f32, tokens[-1].to_f32 }
      elsif line =~ /^f\s/
        tokens = line.split[-3..-1].map &.split /\//

        case tokens[0].size
        when 2
          faces << {
            { tokens[0][0].to_i, tokens[0][1].to_i },
            { tokens[1][0].to_i, tokens[1][1].to_i },
            { tokens[2][0].to_i, tokens[2][1].to_i }
          }
        when 3
          faces << {
            { tokens[0][0].to_i, tokens[0][2].to_i },
            { tokens[1][0].to_i, tokens[1][2].to_i },
            { tokens[2][0].to_i, tokens[2][2].to_i }
          }
        else
          raise "Vertices should have at least 2 data points. (v & vt)"
        end
      end
    end

    triangles = faces.map do |face|
      (0..2).map do |i|
        Vertex.new(
          positions[face[i][0] - 1][0],
          positions[face[i][0] - 1][1],
          positions[face[i][0] - 1][2],
          coordinates[face[i][1] - 1][0],
          coordinates[face[i][1] - 1][1],
        )
      end
    end

    objects[name as String] = triangles

    objects.keys.map { |key| { objects[key], materials[key] } }
  end
end
