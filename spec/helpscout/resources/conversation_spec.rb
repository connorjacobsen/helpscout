# frozen_string_literal: true

RSpec.describe Helpscout::Conversation do
  it_behaves_like 'retrievable' do
    let(:id) { 123 }
    let(:response_body) { ResponseLoader.load_json('get_conversation') }
  end

  it_behaves_like 'listable', filterable: true do
    let(:count) { 1 }
    let(:response_body) { ResponseLoader.load_json('list_conversations') }
    let(:first_id) { 10 }
    let(:filters) do
      {
        mailbox: 123,
        status: 'closed'
      }
    end
  end

  it_behaves_like 'creatable' do
    let(:resource_id) { 1_031_221_011 }
    let(:params) do
      {
        subject: 'Subject',
        customer: {
          email: 'bear@acme.com',
          firstName: 'Vernon',
          lastName: 'Bear'
        },
        mailboxId: 203_359,
        type: 'email',
        status: 'active',
        createdAt: '2012-10-10T12:00:00Z',
        threads: [
          {
            type: 'customer',
            customer: {
              email: 'bear@acme.com'
            },
            text: 'Hello, Help Scout. How are you?'
          }
        ],
        tags: ['vip'],
        fields: [
          { id: 531, value: 'trial' }
        ]
      }
    end
  end

  it_behaves_like 'updatable' do
    let(:id) { 12_345 }
    let(:params) do
      { op: 'replace', path: '/subject', value: 'New Subject' }
    end
  end

  it_behaves_like 'deletable' do
    let(:id) { 12_345 }
  end

  describe 'attachments' do
    let(:parent_id) { 123 }
    let(:resource_name) { :attachment }
    let(:resource_class) { Helpscout::ConversationAttachment }
    let(:resource_path) { 'attachments' }

    describe 'custom methods' do
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

      describe '.retrieve_attachment_data' do
        let(:response_body) { ResponseLoader.load_json('conversations/get_attachment_data') }

        it 'returns success' do
          stubs.get('/v2/conversations/123/attachments/5000/data') do
            [
              200,
              { 'content-type' => 'application/hal+json;charset=UTF-8' },
              response_body
            ]
          end

          outcome = described_class.retrieve_attachment_data(123, 5000)
          expect(outcome).to be_success
          expect(outcome.result.data).to eq('ZmlsZQ==')
        end
      end

      describe '.create_attachment' do
        let(:params) do
          {
            file_name: 'file.txt',
            mime_type: 'text/plain',
            data: 'ZmlsZQ=='
          }
        end

        it 'returns success' do
          stubs.post('/v2/conversations/123/threads/1000/attachments') do |env|
            expect(env.body).to eq(JSON.generate(params))

            [
              201,
              { 'content-type' => 'application/hal+json;charset=UTF-8' },
              ''
            ]
          end

          outcome = described_class.create_attachment(123, 1000, params)
          expect(outcome).to be_success
        end
      end
    end

    it_behaves_like 'nested_deletable' do
      let(:id) { 1234 }
      let(:path) { "/v2/conversations/#{parent_id}/attachments/#{id}" }
    end
  end

  describe 'threads' do
    let(:parent_id) { 123 }
    let(:resource_name) { :thread }
    let(:resource_class) { Helpscout::ConversationThread }
    let(:resource_path) { 'threads' }

    it_behaves_like 'nested_listable' do
      let(:response_body) { ResponseLoader.load_json('conversations/list_threads') }
      let(:first_id) { 1234 }
    end

    it_behaves_like 'nested_updatable' do
      let(:id) { 1234 }
      let(:path) { "/v2/conversations/#{parent_id}/threads/#{id}" }
      let(:params) do
        {
          op: 'replace',
          path: '/text',
          value: 'Nex Text'
        }
      end
    end
  end

  describe 'custom methods' do
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
        customer: {
          id: 456
        },
        text: 'Buy more pens',
        attachments: [
          {
            fileName: 'file.txt',
            mimeType: 'plain/text',
            data: 'ZmlsZQ=='
          }
        ]
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

    describe '.create_chat_thread' do
      it 'returns success' do
        stubs.post('/v2/conversations/123/chats') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.create_chat_thread(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.create_customer_thread' do
      it 'returns success' do
        stubs.post('/v2/conversations/123/customer') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.create_customer_thread(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.create_note' do
      it 'returns success' do
        stubs.post('/v2/conversations/123/notes') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.create_note(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.create_phone_thread' do
      it 'returns success' do
        stubs.post('/v2/conversations/123/phones') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.create_phone_thread(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.create_reply_thread' do
      it 'returns success' do
        stubs.post('/v2/conversations/123/reply') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.create_reply_thread(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.update_fields' do
      let(:params) do
        {
          fields: [
            {
              id: 104,
              value: '168'
            }
          ]
        }
      end

      it 'returns success' do
        stubs.put('/v2/conversations/123/fields') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.update_fields(123, params)
        expect(outcome).to be_success
      end
    end

    describe '.update_tags' do
      let(:params) { { tags: %w[test26 test1] } }

      it 'returns success' do
        stubs.put('/v2/conversations/123/tags') do |env|
          expect(env.body).to eq(JSON.generate(params))

          [
            201,
            { 'content-type' => 'application/hal+json;charset=UTF-8' },
            ''
          ]
        end

        outcome = described_class.update_tags(123, params)
        expect(outcome).to be_success
      end
    end
  end
end
