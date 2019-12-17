# frozen_string_literal: true

RSpec.describe HelpScout::Team do
  it_behaves_like 'listable' do
    let(:count) { 1 }
    let(:response_body) { ResponseLoader.load_json('list_teams') }
    let(:first_id) { 4 }
  end

  describe '.list_members' do
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
    let(:id) { 10 }
    let(:response_body) { ResponseLoader.load_json('list_team_members') }

    before { allow(Faraday::Connection).to receive(:new).and_return(conn) }

    it 'lists team members' do
      stubs.get('/v2/oauth2/token') do
        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          ResponseLoader.load_json('auth_token')
        ]
      end

      stubs.get("/v2/teams/#{id}/members") do
        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          response_body
        ]
      end

      outcome = described_class.list_members(id)
      expect(outcome).to be_success
      expect(outcome.result.first).to be_a(HelpScout::User)
    end
  end
end
