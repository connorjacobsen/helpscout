# frozen_string_literal: true

RSpec.describe Helpscout::Team do
  it_behaves_like 'listable', filterable: true do
    let(:count) { 1 }
    let(:response_body) { ResponseLoader.load_json('list_teams') }
    let(:first_id) { 4 }
    let(:filters) do
      { page: 2 }
    end
  end

  describe '.list_members' do
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
    let(:id) { 10 }
    let(:response_body) { ResponseLoader.load_json('list_team_members') }

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

    it 'lists team members' do
      stubs.get("/v2/teams/#{id}/members") do
        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          response_body
        ]
      end

      outcome = described_class.list_members(id)
      expect(outcome).to be_success
      expect(outcome.result.first).to be_a(Helpscout::User)
    end

    it 'allows filters' do
      stubs.get("/v2/teams/#{id}/members?page=2") do
        [
          200,
          { 'content-type' => 'application/hal+json;charset=UTF-8' },
          response_body
        ]
      end

      outcome = described_class.list_members(id, page: 2)
      expect(outcome).to be_success
      expect(outcome.result.first).to be_a(Helpscout::User)
    end
  end
end
