# frozen_string_literal: true

RSpec.describe HelpScout::Rating do
  it_behaves_like 'retrievable' do
    let(:id) { 1 }
    let(:response_body) { ResponseLoader.load_json('get_rating') }
  end
end
