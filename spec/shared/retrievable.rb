# frozen_string_literal: true

RSpec.shared_examples_for 'retrievable' do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:client) do
    HelpScout::Client.new(
      client_id: 'client-id',
      client_secret: 'client-secret',
      cache: nil,
    )
  end

  before do
    # Nasty way of injecting the stubs adapter into the connection.
    client.instance_variable_get(:@connection).builder.adapter(:test, stubs)
    allow(HelpScout).to receive(:new_client).and_return(client)
  end

  it 'returns the resource' do
    stubs.post('/v2/oauth2/token') do
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

  it 'follows redirects' do
    stubs.post('/v2/oauth2/token') do
      [
        200,
        { 'content-type' => 'application/hal+json;charset=UTF-8' },
        ResponseLoader.load_json('auth_token')
      ]
    end

    redirect_id = 12345
    data = JSON.load(response_body)
    data['id'] = redirect_id
    redirect_body = JSON.generate(data)

    stubs.get("/v2/#{described_class.plural}/#{id}") do
      [
        301,
        {
          'content-type' => 'application/hal+json;charset=UTF-8',
          'location' => "#{HelpScout::DEFAULT_BASE_URI}/v2/#{described_class.plural}/12345"
        },
        ''
      ]
    end


    stubs.get("/v2/#{described_class.plural}/12345") do
      [
        200,
        {
          'content-type' => 'application/hal+json;charset=UTF-8'
        },
        redirect_body
      ]
    end

    outcome = described_class.retrieve(id, {}, client: client)
    expect(outcome).to be_success

    result = outcome.result
    expect(result).to be_a(described_class)
    expect(result.id).to eq(redirect_id)
  end
end
