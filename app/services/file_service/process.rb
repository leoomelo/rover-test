module FileService
  class Process
    attr_reader :results, :plateau

    def initialize(file)
      @file = file
      @results = []
    end

    def call
      lines = @file.read.lines.map(&:strip).reject(&:empty?)
      raise "Empty file or bad formmated" if lines.size < 3

      create_plateau(lines.shift)
      process_rovers(lines)

      @results = @results.map { |pos| pos[:final_position] }
      true
    rescue => e
      @error = e.message
      false
    end

    def error
      @error
    end

    private

    def create_plateau(line)
      width, height = line.split.map(&:to_i)
      raise "Invalid data for plateau" if width.nil? || height.nil?

      @plateau = Plateau.create!(width: width, height: height)
    end

    def process_rovers(lines)
      lines.each_slice(2) do |position_line, command_line|
        raise "Invalid rover line" if command_line.nil?

        pos_x, pos_y, direction = position_line.split
        rover = @plateau.rovers.create!(pos_x: pos_x.to_i, pos_y: pos_y.to_i, direction: direction)

        unless rover.execute_commands(command_line)
          raise "Execute commands has failed for rover -  #{rover.id}: #{rover.errors.full_messages.join(', ')}"
        end

        rover.save!
        @results << {
          id: rover.id,
          final_position: "#{rover.pos_x} #{rover.pos_y} #{rover.direction}"
        }
      end
    end
  end
end
