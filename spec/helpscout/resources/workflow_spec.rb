# frozen_string_literal: true

RSpec.describe HelpScout::Workflow do
  it_behaves_like 'listable' do
    let(:count) { 1 }
    let(:response_body) { ResponseLoader.load_json('list_workflows') }
    let(:first_id) { 1234 }
  end

  it_behaves_like 'updatable' do
    let(:id) { 20 }
    let(:params) do
      {
        value: 'active',
        op: 'replace',
        path: '/status'
      }
    end
  end
end
