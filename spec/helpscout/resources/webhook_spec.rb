# frozen_string_literal: true

RSpec.describe HelpScout::Webhook do
  let(:id) { 10 }
  let(:resource_id) { id }
  let(:first_id) { id }
  let(:params) do
    {
      url: 'https:\\/\\/example.com/helpscout',
      events: ['convo.assigned'],
      secret: 'some-secret'
    }
  end

  it_behaves_like 'retrievable' do
    let(:response_body) { ResponseLoader.load_json('get_webhook') }
  end

  it_behaves_like 'listable' do
    let(:count) { 1 }
    let(:response_body) { ResponseLoader.load_json('list_webhooks') }
  end

  it_behaves_like 'creatable'

  it_behaves_like 'updatable'

  it_behaves_like 'deletable'
end
