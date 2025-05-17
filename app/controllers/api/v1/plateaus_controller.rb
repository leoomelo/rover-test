class Api::V1::PlateausController < ApplicationController
  def index
    render json: Plateau.all, status: :ok
  end

  def create
    plateau = Plateau.create!(plateau_params)
    render json: plateau, status: :created
  end

  private

  def plateau_params
    params.permit(:width, :height)
  end
end
