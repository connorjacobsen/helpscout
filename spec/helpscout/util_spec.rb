# frozen_string_literal: true

RSpec.describe HelpScout::Util do
  describe '.underscore' do
    it 'works' do
      expect(described_class.underscore('FooBar')).to eq('foo_bar')
      expect(described_class.underscore('fooBar')).to eq('foo_bar')
      expect(described_class.underscore('foobar')).to eq('foobar')
    end
  end
end
