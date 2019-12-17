# frozen_string_literal: true

RSpec.describe HelpScout::Client do
  let(:client_id) { 'some-client-id' }
  let(:client_secret) { 'some-client-secret' }
  let(:cache) { nil }

  describe '#initialize' do
    it 'creates a new client with connection' do
      expect(Faraday::Connection).to receive(:new)
        .with(HelpScout::DEFAULT_BASE_URI, headers: described_class::DEFAULT_HEADERS)

      client = described_class.new(
        client_id: client_id,
        client_secret: client_secret,
        cache: cache
      )

      expect(client.client_id).to eq(client_id)
      expect(client.client_secret).to eq(client_secret)
      expect(client.cache).to eq(cache)
    end

    it 'throws an error when missing required options' do
      expect {
        described_class.new
      }.to raise_exception(ArgumentError)
    end
  end

  describe '#execute_request' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:conn) { Faraday.new { |b| b.adapter(:test, stubs) } }

    let(:client) do
      described_class.new(
        client_id: client_id,
        client_secret: client_secret,
        cache: cache,
        connection: conn
      )
    end

    before { allow(Faraday).to receive(:new).and_return(conn) }

    # This is slow. Consider unrolling.
    %i[get post put patch delete].each do |method|
      it "sends a #{method.to_s.upcase} request" do
        stubs.send(method, '/v2/items') do |env|
          expect(env.method).to eq(method)
          expect(env.url.path).to eq('/v2/items')
          expect(env.params).to eq({})
          [
            200,
            { 'Content-Type' => 'application/json' },
            JSON.generate(hello: 'world')
          ]
        end

        client.execute_request(method, '/v2/items')
      end
    end
  end
end
