require 'rails_helper'

RSpec.describe "Plateaus", type: :request do
  describe "GET /api/v1/plateaus" do
    let!(:plateau) { create(:plateau, width: 5, height: 5) }
    it "returns a list of plateaus" do
      get "/api/v1/plateaus"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to be >= 1
    end
  end

  describe "POST /api/v1/plateaus" do
    it "creates a new plateau" do
      post "/api/v1/plateaus", params: { width: 5, height: 5 }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["width"]).to eq(5)
    end
  end
end
