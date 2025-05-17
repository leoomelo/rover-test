require 'swagger_helper'

RSpec.describe 'Plateaus API', type: :request do
  path '/api/v1/plateaus' do
    get('list plateaus') do
      tags 'Plateaus'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   width: { type: :integer },
                   height: { type: :integer }
                 },
                 required: %w[id width height]
               }

        before do
          Plateau.create!(width: 5, height: 5)
        end

        run_test!
      end
    end

    post('create plateau') do
      tags 'Plateaus'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :plateau, in: :body, schema: {
        type: :object,
        properties: {
          width: { type: :integer },
          height: { type: :integer }
        },
        required: %w[width height]
      }

      response(201, 'created') do
        let(:plateau) { { width: 6, height: 6 } }
        run_test!
      end

      response(422, 'invalid request') do
        let(:plateau) { { width: nil, height: 6 } }
        run_test!
      end
    end
  end

  path '/api/v1/plateaus/upload' do
    post 'Uploads a file' do
      tags 'Upload'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :file, in: :formData, type: :file, required: true, description: 'File to upload'

      response '200', 'file uploaded' do
        let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/rover_test.txt'), 'text/plain') }

        run_test!
      end

      response '400', 'missing file' do
        let(:file) { nil }
        run_test!
      end
    end
  end
end
