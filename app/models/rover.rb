class Rover < ApplicationRecord
  DIRECTIONS = %w[N E S W].freeze

  belongs_to :plateau

  validates :pos_x, :pos_y, presence: true, numericality: true
  validates :plateau, presence: true
  validates :direction, inclusion: { in: DIRECTIONS }, presence: true
  validate :position_belongs_plateau, if: -> { plateau.present? && pos_x.present? && pos_y.present? }

  def position_belongs_plateau
    unless plateau.within_bounds?(pos_x, pos_y)
      errors.add(:base, "Rover position (#{pos_x}, #{pos_y}) is outside the Plateau (#{plateau.width}, #{plateau.height})")
    end
  end

  def execute_commands(commands)
    RoverService::Movement.new(self).call(commands)
  end
end
