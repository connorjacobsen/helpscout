# frozen_string_literal: true

RSpec.describe HelpScout::ListObject do
  describe 'enumerable' do
    subject { described_class.new([1, 2, 3]) }

    it 'responds to #size' do
      expect(subject.count).to eq(3)
    end
  end
end
