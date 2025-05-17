require 'rails_helper'

RSpec.describe FileService::Process, type: :service do
  let(:valid_file_content) do
    <<~TXT
      5 5
      1 2 N
      LMLMLMLMM
      3 3 E
      MMRMMRMRRM
    TXT
  end

  let(:file) { StringIO.new(valid_file_content) }

  describe '#call' do
    it 'should process the file and commands' do
      service = described_class.new(file)
      expect(service.call).to be true

      expect(service.plateau.width).to eq(5)
      expect(service.plateau.height).to eq(5)
      expect(service.results.length).to eq(2)

      expect(service.results[0]).to eq("1 3 N")
      expect(service.results[1]).to eq("5 1 E")
    end

    it 'should return an error if the file is empty' do
      empty_file = StringIO.new("")
      service = described_class.new(empty_file)

      expect(service.call).to be false
      expect(service.error).to match(/Empty file or bad formmated/)
    end

    it 'should return an error if the file is bad formatted' do
      invalid_content = <<~TXT
        5 5
        1 2 N
      TXT
      service = described_class.new(StringIO.new(invalid_content))

      expect(service.call).to be false
      expect(service.error).to match(/Empty file or bad formmated/)
    end
  end
end
