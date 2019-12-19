# frozen_string_literal: true

RSpec.describe Helpscout::Link do
  let(:href) { 'https://api.helpscout.net/v2/conversations/281801848' }

  it 'initializes properly' do
    link = described_class.new('self', href)
    expect(link.name).to eq('self')
    expect(link.href).to eq(href)
    expect(link).not_to be_templated
  end

  it 'optional templated arg' do
    link = described_class.new('self', href, true)
    expect(link.name).to eq('self')
    expect(link.href).to eq(href)
    expect(link).to be_templated
  end
end
