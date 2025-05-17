class Api::V1::RoversController < ApplicationController
  before_action :set_plateau, only: [ :create, :commands ]

  def create
    rover = @plateau.rovers.create!(rover_params)
    render json: rover, status: :created
  end

  def commands
    rover = @plateau.rovers.find(params[:id])
    rover.execute_commands(params[:commands])
    render json: serialize_rover(rover)
  end

  private

  def set_plateau
    @plateau = Plateau.find(params[:plateau_id])
  end

  def rover_params
    params.permit(:pos_x, :pos_y, :direction)
  end

  def serialize_rover(rover)
    [ rover.pos_x, rover.pos_y, rover.direction ]
  end
end
