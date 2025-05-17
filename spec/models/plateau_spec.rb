require 'rails_helper'

RSpec.describe Plateau, type: :model do
  describe 'validations' do
    context 'valid' do
      it do
        plateau = Plateau.new(width: 5, height: 5)
        expect(plateau).to be_valid
      end
    end

    context 'not_valid' do
      it 'is invalid without width' do
        plateau = Plateau.new(width: nil, height: 5)
        expect(plateau).not_to be_valid
      end

      it 'is invalid without height' do
        plateau = Plateau.new(width: 5, height: nil)
        expect(plateau).not_to be_valid
      end

      it 'is invalid if one field not numeric' do
        plateau = Plateau.new(width: 'a', height: 5)
        expect(plateau).not_to be_valid
      end

      it 'is invalid if one field is less than 0' do
        plateau = Plateau.new(width: -1, height: 5)
        expect(plateau).not_to be_valid
      end
    end
  end
end
