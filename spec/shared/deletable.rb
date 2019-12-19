# frozen_string_literal: true

RSpec.shared_examples_for 'deletable' do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) do
    Helpscout::Client.new(
      client_id: 'client-id',
      client_secret: 'client-secret',
      cache: nil,
      connection: conn
    )
  end

  before do
    allow(Faraday::Connection).to receive(:new).and_return(conn)
  end

  it 'returns success' do
    stubs.get('/v2/oauth2/token') do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        ResponseLoader.load_json('auth_token')
      ]
    end

    stubs.delete("/v2/#{described_class.plural}/#{id}") do
      [
        204,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        ''
      ]
    end

    outcome = described_class.delete(id)
    expect(outcome).to be_success
    expect(outcome.status).to eq(204)
  end
end
