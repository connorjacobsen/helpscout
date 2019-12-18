# frozen_string_literal: true

RSpec.describe HelpScout::User do
  it_behaves_like 'retrievable' do
    let(:id) { 4 }
    let(:response_body) { ResponseLoader.load_json('get_user') }
  end

  it_behaves_like 'listable', filterable: true do
    let(:count) { 1 }
    let(:response_body) { ResponseLoader.load_json('list_users') }
    let(:first_id) { 4 }
    let(:filters) do
      {
        email: 'bear@acme.com',
        mailbox: 123
      }
    end
  end

  describe '.resource_owner' do
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
    let(:response_body) { ResponseLoader.load_json('get_resource_owner') }

    before { allow(Faraday::Connection).to receive(:new).and_return(conn) }

    it 'returns a user' do
      stubs.get('/v2/oauth2/token') do
        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          ResponseLoader.load_json('auth_token')
        ]
      end

      stubs.get('/v2/users/me') do |env|
        expect(env.params).to eq({})

        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          response_body
        ]
      end

      outcome = described_class.retrieve_resource_owner
      expect(outcome).to be_success
      expect(outcome.result.id).to eq(4)
      expect(outcome.result.first_name).to eq('Vernon')
      expect(outcome.result.last_name).to eq('Bear')
      expect(outcome.result.email).to eq('bear@acme.com')
      expect(outcome.result.role).to eq('owner')
    end
  end
end
