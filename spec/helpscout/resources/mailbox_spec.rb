# frozen_string_literal: true

RSpec.describe Helpscout::Mailbox do
  it_behaves_like 'retrievable' do
    let(:id) { 1 }
    let(:response_body) { ResponseLoader.load_json('get_mailbox') }
  end

  it_behaves_like 'listable' do
    let(:count) { 2 }
    let(:response_body) { ResponseLoader.load_json('list_mailboxes') }
    let(:first_id) { 1 }
  end

  it_behaves_like 'nested_listable' do
    let(:parent_id) { 10 }
    let(:response_body) { ResponseLoader.load_json('list_mailbox_folders') }
    let(:resource_name) { :folder }
    let(:resource_class) { Helpscout::MailboxFolder }
    let(:resource_path) { 'folders' }
    let(:first_id) { 1234 }
  end

  it_behaves_like 'nested_listable' do
    let(:parent_id) { 1 }
    let(:response_body) { ResponseLoader.load_json('list_mailbox_custom_fields') }
    let(:resource_name) { :field }
    let(:resource_class) { Helpscout::MailboxField }
    let(:resource_path) { 'fields' }
    let(:first_id) { 104 }
  end
end
