require 'rails_helper'

RSpec.describe "Rovers", type: :request do
  let!(:plateau) { Plateau.create!(width: 5, height: 5) }

  describe "POST /api/v1/plateaus/:id/rovers" do
    it "creates a new rover on a plateau" do
      post "/api/v1/plateaus/#{plateau.id}/rovers", params: {
          pos_x: 1,
          pos_y: 2,
          direction: "N"
        }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["pos_x"]).to eq(1)
      expect(json["direction"]).to eq("N")
    end
  end
end
