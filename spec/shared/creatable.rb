# frozen_string_literal: true

RSpec.shared_examples_for 'creatable' do
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
  let(:plural) { described_class.plural }
  let(:response_headers) do
    {
      'content-type' => 'application/hal+json;charset=UTF-8',
      'resource-id' => resource_id.to_s,
      'location' => "https://api.helpscout.new/v2/#{plural}/#{resource_id}"
    }
  end

  before do
    allow(Faraday::Connection).to receive(:new).and_return(conn)
  end

  context 'success' do
    it 'returns a 201' do
      stubs.get('/v2/oauth2/token') do
        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          ResponseLoader.load_json('auth_token')
        ]
      end

      stubs.post("/v2/#{plural}") do |env|
        expect(env.body).to eq(JSON.generate(params))
        [
          201,
          response_headers,
          ''
        ]
      end

      outcome = described_class.create(params)
      expect(outcome).to be_success
      expect(outcome.result.id).to eq(resource_id)
    end
  end
end
