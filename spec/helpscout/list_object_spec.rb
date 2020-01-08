# frozen_string_literal: true

require 'pry'

RSpec.describe HelpScout::ListObject do
  describe 'enumerable' do
    subject { described_class.new([1, 2, 3]) }

    it 'responds to #size' do
      expect(subject.count).to eq(3)
    end
  end

  describe '#page' do
    let(:page) do
      {
        size: 50,
        total_elements: 0,
        total_pages: 0,
        number: 0
      }
    end

    it 'returns pagination data' do
      obj = described_class.new([], [], page)
      expect(obj.page.size).to eq(50)
      expect(obj.page.total_elements).to eq(0)
      expect(obj.page.total_pages).to eq(0)
      expect(obj.page.number).to eq(0)
    end
  end
end
