class Api::V1::PlateausController < ApplicationController
  def index
    render json: Plateau.all, status: :ok
  end

  def create
    plateau = Plateau.create!(plateau_params)
    render json: plateau, status: :created
  end

  def upload
    file = params[:file]
    if file.nil? || file.blank?
      render json: { error: "File not sent" }, status: :bad_request
      return
    end

    service = FileService::Process.new(params[:file])

    if service.call
      render json: {
        positions: service.results
      }
    else
      render json: { error: service.error }, status: :unprocessable_entity
    end
  end

  private

  def plateau_params
    params.permit(:width, :height)
  end
end
