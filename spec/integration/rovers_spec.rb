require 'swagger_helper'

RSpec.describe 'Rovers API', type: :request do
  path '/api/v1/plateaus/{plateau_id}/rovers' do
    post('create rover') do
      tags 'Rovers'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :plateau_id, in: :path, type: :integer
      parameter name: :rover, in: :body, schema: {
        type: :object,
        properties: {
          pos_x: { type: :integer },
          pos_y: { type: :integer },
          direction: { type: :string, enum: %w[N E S W] }
        },
        required: %w[pos_x pos_y direction]
      }

      response(201, 'created') do
        let!(:plateau) { Plateau.create!(width: 5, height: 5) }
        let(:plateau_id) { plateau.id }

        let(:rover) do
          {
            pos_x: 1,
            pos_y: 2,
            direction: 'N'
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/plateaus/{plateau_id}/rovers/{id}/commands' do
    post('send commands to rover') do
      tags 'Rovers'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :plateau_id, in: :path, type: :integer, description: 'Plateau ID'
      parameter name: :id, in: :path, type: :integer, description: 'Rover ID'

      parameter name: :command, in: :body, schema: {
        type: :object,
        properties: {
          commands: { type: :string, example: 'MMRMMRMRRM'}
        },
        required: ['commands']
      }

      response(200, 'commands executed successfully') do
        let!(:plateau) { Plateau.create!(width: 5, height: 5) }
        let!(:rover) do
          Rover.create!(
            plateau: plateau,
            pos_x: 1,
            pos_y: 2,
            direction: 'N'
          )
        end

        let(:plateau_id) { plateau.id }
        let(:id) { rover.id }
        let(:command) { { commands: 'MMRMMRMRRM' } }

        run_test!
      end

      response(422, 'invalid commands') do
        let(:plateau_id) { 1 }
        let(:id) { 1 }
        let(:command) { { commands: 'INVALID' } }

        run_test!
      end
    end
  end
end
