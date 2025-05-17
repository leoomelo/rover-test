require 'rails_helper'

RSpec.describe Rover, type: :model do
  describe 'validations' do
    let!(:plateau) { create(:plateau, width: 5, height: 5) }

    context 'valid' do
      it do
        rover = Rover.new(pos_x: 1, pos_y: 2, direction: 'N', plateau: plateau)
        expect(rover).to be_valid
      end
    end

    context 'not_valid' do
      it 'is invalid without a plateau' do
        rover = Rover.new(pos_x: 1, pos_y: 2, direction: 'N', plateau: nil)
        expect(rover).not_to be_valid
      end

      it 'is invalid without any positions' do
        rover = Rover.new(pos_x: nil, pos_y: 2, direction: 'N', plateau: plateau)
        expect(rover).not_to be_valid

        rover = Rover.new(pos_x: 1, pos_y: nil, direction: 'N', plateau: plateau)
        expect(rover).not_to be_valid
      end

      it 'is invalid without a direction' do
        rover = Rover.new(pos_x: 1, pos_y: 2, direction: nil, plateau: plateau)
        expect(rover).not_to be_valid
      end

      it 'is invalid with a not permitted direction' do
        rover = Rover.new(pos_x: 1, pos_y: 2, direction: 'A', plateau: plateau)
        expect(rover).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:plateau) }
  end

  describe 'limit' do
    let!(:plateau) { create(:plateau, width: 5, height: 5) }

    it do
      expect { Rover.create!(pos_x: 10, pos_y: 0, direction: 'N', plateau: plateau) }.to raise_error(ActiveRecord::RecordInvalid)
      rover = Rover.create(pos_x: 10, pos_y: 0, direction: 'N', plateau: plateau)
      expect(rover.errors.full_messages).to include "Rover position (10, 0) is outside the Plateau (5, 5)"
    end
  end
end
