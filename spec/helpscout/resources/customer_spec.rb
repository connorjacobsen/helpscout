# frozen_string_literal: true

RSpec.describe Helpscout::Customer do
  it_behaves_like 'retrievable' do
    let(:id) { 500 }
    let(:response_body) { ResponseLoader.load_json('get_customer') }
  end

  it_behaves_like 'listable' do
    let(:count) { 2 }
    let(:response_body) { ResponseLoader.load_json('list_customers') }
    let(:first_id) { 1 }
  end

  it_behaves_like 'creatable' do
    let(:resource_id) { 101 }
    let(:params) do
      {
        first_name: 'Vernon',
        last_name: 'Bear',
        photo_url: 'https://api.helpscout.net/img/some-avatar.jpg',
        photo_type: 'twitter',
        job_title: 'CEO and Co-Founder',
        location: 'Greater Dallas/FT Worth Area',
        background: "I've worked with Vernon before and he's really great.",
        age: '30-35',
        gender: 'male',
        organization: 'Acme, Inc',
        emails: [
          { type: 'work', value: 'bear@acme.com' }
        ]
      }
    end
  end

  it_behaves_like 'updatable' do
    let(:id) { 101 }
    let(:params) do
      {
        first_name: 'Vernon',
        last_name: 'Bear',
        photo_url: 'https://api.helpscout.net/img/some-avatar.jpg',
        photo_type: 'twitter',
        job_title: 'CEO and Co-Founder',
        location: 'Greater Dallas/FT Worth Area',
        background: "I've worked with Vernon before and he's really great.",
        age: '30-35',
        gender: 'male',
        organization: 'Acme, Inc'
      }
    end
  end

  ## Address

  describe 'address' do
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
    let(:params) do
      {
        city: 'Dallas',
        state: 'TX',
        postal_code: '74206',
        country: 'US',
        lines: ['123 West Main St', 'Suite 123']
      }
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

    describe '.create_address' do
      it 'returns success' do
        stubs.post('/v2/customers/123/address') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.create_address(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.retrieve_address' do
      let(:response_body) { ResponseLoader.load_json('customers/get_address') }

      it 'returns address' do
        stubs.get('/v2/customers/123/address') do
          [
            200,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            response_body
          ]
        end

        outcome = described_class.retrieve_address(123)
        expect(outcome).to be_success

        result = outcome.result
        expect(result).to be_a(Helpscout::CustomerAddress)
        expect(result.city).to eq('Dallas')
        expect(result.state).to eq('TX')
        expect(result.postal_code).to eq('74206')
        expect(result.country).to eq('US')
      end
    end

    describe '.update_address' do
      it 'returns success' do
        stubs.patch('/v2/customers/123/address') do |env|
          expect(env.body).to eq(JSON.generate(params))
          [
            204,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.update_address(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.delete_address' do
      it 'returns success' do
        stubs.delete('/v2/customers/123/address') do
          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.delete_address(123)
        expect(outcome).to be_success
      end
    end
  end

  ## Chat

  describe 'chats' do
    let(:parent_id) { 10 }
    let(:resource_name) { :chat }
    let(:resource_class) { Helpscout::CustomerChat }
    let(:resource_path) { 'chats' }

    it_behaves_like 'nested_listable' do
      let(:response_body) { ResponseLoader.load_json('customers/list_chat_handles') }
      let(:first_id) { 1 }
    end

    it_behaves_like 'nested_creatable' do
      let(:path) { "/v2/customers/#{parent_id}/chats" }
      let(:resource_id) { 1234 }
      let(:params) do
        {
          type: 'aim',
          value: 'jsprout'
        }
      end
    end

    it_behaves_like 'nested_updatable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/chats/#{id}" }
      let(:params) do
        {
          type: 'aim',
          value: 'jsprout'
        }
      end
    end

    it_behaves_like 'nested_deletable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/chats/#{id}" }
    end
  end

  ## Email

  describe 'emails' do
    let(:parent_id) { 10 }
    let(:resource_name) { :email }
    let(:resource_class) { Helpscout::CustomerEmail }
    let(:resource_path) { 'emails' }

    it_behaves_like 'nested_listable' do
      let(:response_body) { ResponseLoader.load_json('customers/list_emails') }
      let(:first_id) { 1 }
    end

    it_behaves_like 'nested_creatable' do
      let(:path) { "/v2/customers/#{parent_id}/emails" }
      let(:resource_id) { 1234 }
      let(:params) do
        {
          type: 'work',
          value: 'dasilva@football.com'
        }
      end
    end

    it_behaves_like 'nested_updatable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/emails/#{id}" }
      let(:params) do
        {
          type: 'work',
          value: 'dasilva@football.com'
        }
      end
    end

    it_behaves_like 'nested_deletable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/emails/#{id}" }
    end
  end

  ## Phone

  describe 'phones' do
    let(:parent_id) { 10 }
    let(:resource_name) { :phone }
    let(:resource_class) { Helpscout::CustomerPhone }
    let(:resource_path) { 'phones' }

    it_behaves_like 'nested_listable' do
      let(:response_body) { ResponseLoader.load_json('customers/list_phones') }
      let(:first_id) { 1 }
    end

    it_behaves_like 'nested_creatable' do
      let(:path) { "/v2/customers/#{parent_id}/phones" }
      let(:resource_id) { 1234 }
      let(:params) do
        {
          type: 'work',
          value: '222-333-4444'
        }
      end
    end

    it_behaves_like 'nested_updatable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/phones/#{id}" }
      let(:params) do
        {
          type: 'work',
          value: '222-333-4445'
        }
      end
    end

    it_behaves_like 'nested_deletable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/phones/#{id}" }
    end
  end

  ## SocialProfile

  describe 'social profiles' do
    let(:parent_id) { 10 }
    let(:resource_name) { :social_profile }
    let(:resource_class) { Helpscout::CustomerSocialProfile }
    let(:resource_path) { 'social-profiles' }

    it_behaves_like 'nested_listable' do
      let(:response_body) { ResponseLoader.load_json('customers/list_social_profiles') }
      let(:first_id) { 1 }
    end

    it_behaves_like 'nested_creatable' do
      let(:path) { "/v2/customers/#{parent_id}/social-profiles" }
      let(:resource_id) { 1234 }
      let(:params) do
        {
          type: 'twitter',
          value: 'https://twitter.com/@helpscout'
        }
      end
    end

    it_behaves_like 'nested_updatable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/social-profiles/#{id}" }
      let(:params) do
        {
          type: 'twitter',
          value: 'https://twitter.com/@helpscout'
        }
      end
    end

    it_behaves_like 'nested_deletable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/social-profiles/#{id}" }
    end
  end

  ## Website

  describe 'websites' do
    let(:parent_id) { 10 }
    let(:resource_name) { :website }
    let(:resource_class) { Helpscout::CustomerWebsite }
    let(:resource_path) { 'websites' }

    it_behaves_like 'nested_listable' do
      let(:response_body) { ResponseLoader.load_json('customers/list_websites') }
      let(:first_id) { 1 }
    end

    it_behaves_like 'nested_creatable' do
      let(:path) { "/v2/customers/#{parent_id}/websites" }
      let(:resource_id) { 1234 }
      let(:params) { { value: 'https://api.helpscout.net/' } }
    end

    it_behaves_like 'nested_updatable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/websites/#{id}" }
      let(:params) { { value: 'https://api.helpscout.net/' } }
    end

    it_behaves_like 'nested_deletable' do
      let(:id) { 1234 }
      let(:path) { "/v2/customers/#{parent_id}/websites/#{id}" }
    end
  end
end
