module RoverService
  class Movement
    VALID_COMMANDS = %w[L R M].freeze

    TURN_LEFT = {
      "N" => "W",
      "W" => "S",
      "S" => "E",
      "E" => "N"
    }

    TURN_RIGHT = {
      "N" => "E",
      "E" => "S",
      "S" => "W",
      "W" => "N"
    }

    def initialize(rover)
      @rover = rover
    end

    def call(commands)
      commands.each_char do |command|
        next unless VALID_COMMANDS.include?(command)

        case command
        when "L" then turn_left
        when "R" then turn_right
        when "M" then move_forward
        end
      end
      @rover
    end

    private

    def turn_left
      @rover.direction = TURN_LEFT[@rover.direction]
    end

    def turn_right
      @rover.direction = TURN_RIGHT[@rover.direction]
    end

    def move_forward
      pos_x, pos_y = @rover.pos_x, @rover.pos_y

      case @rover.direction
      when "N" then pos_y += 1
      when "E" then pos_x += 1
      when "S" then pos_y -= 1
      when "W" then pos_x -= 1
      end

      if @rover.plateau.within_bounds?(pos_x, pos_y)
        @rover.pos_x, @rover.pos_y = pos_x, pos_y
      else
        puts "Ignoring movement. Rover is out of plateau's limit "
      end
    end
  end
end
