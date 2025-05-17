Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  namespace :api do
    namespace :v1 do
      resources :plateaus, only: [ :index, :create ] do
        resources :rovers, only: [ :create ] do
          post :commands, on: :member
        end
      end
      post "/plateaus/upload", to: "plateaus#upload"
    end
  end
end
