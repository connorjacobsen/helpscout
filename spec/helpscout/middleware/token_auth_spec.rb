# frozen_string_literal: true

require 'uri'

RSpec.describe HelpScout::Middleware::TokenAuth do
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
    described_class.new(->(env) { env })
  end

  describe '#call' do
    let(:response) { double('Response') }
    let(:body) { ResponseLoader.load_json('auth_token') }

    before do
      allow(HelpScout::AuthToken).to receive(:create)
        .and_return([response, {}])
      allow(response).to receive(:success?).and_return(success)
      allow(response).to receive(:body).and_return(body)
      allow(response).to receive(:status).and_return(status)
    end

    context 'on success' do
      let(:success) { true }
      let(:status) { 200 }

      it 'adds an authorization token' do
        token = "Bearer #{JSON.parse(body, symbolize_names: true)[:access_token]}"
        expect(auth_header(request)).to eq(token)
      end
    end

    context 'on failure' do
      let(:success) { false }
      let(:status) { 401 }

      it 'raises an error' do
        expect { request }.to raise_exception(HelpScout::ClientError)
      end
    end
  end
end
