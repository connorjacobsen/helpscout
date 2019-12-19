# frozen_string_literal: true

RSpec.shared_examples_for 'updatable' do
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

    stubs.patch("/v2/#{described_class.plural}/#{id}") do |env|
      expect(env.body).to eq(JSON.generate(params))
      [
        204,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        ''
      ]
    end

    outcome = described_class.update(id, params)
    expect(outcome).to be_success
    expect(outcome.status).to eq(204)
  end
end
