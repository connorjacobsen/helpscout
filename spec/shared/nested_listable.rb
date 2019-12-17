# frozen_string_literal: true

RSpec.shared_examples_for 'nested_listable' do
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

  it 'returns a list of the nested resources' do
    stubs.get('/v2/oauth2/token') do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        ResponseLoader.load_json('auth_token')
      ]
    end

    stubs.get("/v2/#{described_class.plural}/#{parent_id}/#{resource_path}") do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        response_body
      ]
    end

    outcome = described_class.send(:"list_#{resource_name}s", parent_id)
    expect(outcome).to be_success

    results = outcome.result
    expect(results).to be_a(HelpScout::ListObject)
    expect(results.first).to be_a(resource_class)
    expect(results.first.id).to eq(first_id)
  end
end
