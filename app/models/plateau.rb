class Plateau < ApplicationRecord
  has_many :rovers
  validates :width, :height, presence: true, numericality: { greater_than: 0 }

  def within_bounds?(pos_x, pos_y)
    pos_x.between?(0, width) && pos_y.between?(0, height)
  end
end
