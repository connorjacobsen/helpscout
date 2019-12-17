# frozen_string_literal: true

RSpec.describe HelpScout::Tag do
  it_behaves_like 'listable' do
    let(:count) { 2 }
    let(:response_body) { ResponseLoader.load_json('list_tags') }
    let(:first_id) { 123_456_793 }
  end
end
