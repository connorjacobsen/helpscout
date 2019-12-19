# frozen_string_literal: true

RSpec.shared_examples_for 'listable' do |filterable: false|
  let(:filters) { nil }
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

    stubs.get('/v2/oauth2/token') do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        ResponseLoader.load_json('auth_token')
      ]
    end
  end

  it 'returns a list of resources' do
    stubs.get("/v2/#{described_class.plural}") do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        response_body
      ]
    end

    outcome = described_class.list
    expect(outcome).to be_success

    results = outcome.result
    expect(results).to be_a(Helpscout::ListObject)
    expect(results.first).to be_a(described_class)
    expect(results.first.id).to eq(first_id)
  end

  if filterable
    it 'allows filters' do
      query = Faraday::Utils.build_query(filters)

      stubs.get("/v2/#{described_class.plural}?#{query}") do |_env|
        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          response_body
        ]
      end

      outcome = described_class.list(filters)
      expect(outcome).to be_success

      results = outcome.result
      expect(results).to be_a(Helpscout::ListObject)
      expect(results.first).to be_a(described_class)
      expect(results.first.id).to eq(first_id)
    end
  end
end
