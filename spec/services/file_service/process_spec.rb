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
    it 'processa corretamente o arquivo e executa os comandos' do
      service = described_class.new(file)
      expect(service.call).to be true

      expect(service.plateau.width).to eq(5)
      expect(service.plateau.height).to eq(5)
      expect(service.results.length).to eq(2)

      expect(service.results[0][:final_position]).to eq("1 3 N")
      expect(service.results[1][:final_position]).to eq("5 1 E")
    end

    it 'retorna erro se o arquivo estiver vazio' do
      empty_file = StringIO.new("")
      service = described_class.new(empty_file)

      expect(service.call).to be false
      expect(service.error).to match(/Arquivo vazio/)
    end

    it 'retorna erro se faltar linha de comandos' do
      invalid_content = <<~TXT
        5 5
        1 2 N
      TXT
      service = described_class.new(StringIO.new(invalid_content))

      expect(service.call).to be false
      expect(service.error).to match(/Par de linhas inválido/)
    end
  end
end
