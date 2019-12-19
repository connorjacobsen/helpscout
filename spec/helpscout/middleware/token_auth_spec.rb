# frozen_string_literal: true

require 'uri'
require 'pry'

RSpec.describe Helpscout::Middleware::TokenAuth do
  def auth_header(env)
    env[:request_headers]['authorization']
  end

  def request
    env = {
      url: URI('http://example.com'),
      request_headers: Faraday::Utils::Headers.new
    }
    app = make_app
    app.call(Faraday::Env.from(env))
  end

  def make_app
    described_class.new(->(env) { env }, options)
  end

  describe '#call' do
    let(:options) { {} }
    let(:response) { double('Response') }
    let(:body) { ResponseLoader.load_json('auth_token') }
    let(:success) { true }
    let(:status) { 200 }

    before do
      allow(Helpscout::AuthToken).to receive(:create)
        .and_return([response, {}])
      allow(response).to receive(:success?).and_return(success)
      allow(response).to receive(:body).and_return(body)
      allow(response).to receive(:status).and_return(status)
    end

    context 'without cache' do
      it 'adds an authorization token' do
        token = "Bearer #{JSON.parse(body, symbolize_names: true)[:access_token]}"
        expect(auth_header(request)).to eq(token)
      end

      context 'on failure' do
        let(:success) { false }
        let(:status) { 401 }

        it 'raises an error' do
          expect { request }.to raise_exception(Helpscout::ClientError)
        end
      end
    end

    context 'with cache' do
      let(:expiry) { 60 }
      let(:cache) do
        Moneta.build do
          use :Expires
          adapter :Memory
        end
      end
      let(:options) { { cache: cache, expiry: expiry } }
      let(:token) { 'this-is-an-auth-token' }

      context 'cache hit' do
        it 'returns cached value' do
          expect(Helpscout::AuthToken).not_to receive(:create)
          cache.store(described_class::CACHE_KEY, token, expires: expiry)

          expect(auth_header(request)).to eq("Bearer #{token}")
        end

        it 'fetches new auth token when expired' do
          fetched_token = "Bearer #{JSON.parse(body, symbolize_names: true)[:access_token]}"
          cache.store(described_class::CACHE_KEY, token, expires: 1)
          sleep(1)

          expect(auth_header(request)).to eq(fetched_token)
        end
      end

      context 'cache miss' do
        it 'fetches new auth token' do
          fetched_token = "Bearer #{JSON.parse(body, symbolize_names: true)[:access_token]}"
          expect(auth_header(request)).to eq(fetched_token)
        end
      end
    end
  end
end
