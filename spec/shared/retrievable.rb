# frozen_string_literal: true

RSpec.shared_examples_for 'retrievable' do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) do
    HelpScout::Client.new(
      client_id: 'client-id',
      client_secret: 'client-secret',
      cache: nil,
      connection: conn
    )
  end

  before do
    allow(Faraday::Connection).to receive(:new).and_return(conn)
  end

  it 'returns the resource' do
    stubs.get('/v2/oauth2/token') do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        ResponseLoader.load_json('auth_token')
      ]
    end

    stubs.get("/v2/#{described_class.plural}/#{id}") do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        response_body
      ]
    end

    outcome = described_class.retrieve(id)
    expect(outcome).to be_success

    result = outcome.result
    expect(result).to be_a(described_class)
    expect(result.id).to eq(id)
  end
end
