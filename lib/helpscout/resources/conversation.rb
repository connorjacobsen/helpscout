# frozen_string_literal: true

module Helpscout
  class Conversation < Helpscout::Resource
    include Helpscout::API::Create
    include Helpscout::API::Retrieve
    include Helpscout::API::List
    include Helpscout::API::Update
    include Helpscout::API::Delete
    include Helpscout::API::NestedResource

    OBJECT_NAME = 'conversation'

    custom_resource_method :create_chat_thread,
                           http_verb: :post,
                           http_path: 'chats',
                           object_name: Helpscout::ConversationThread::OBJECT_NAME

    custom_resource_method :create_customer_thread,
                           http_verb: :post,
                           http_path: 'customer',
                           object_name: Helpscout::ConversationThread::OBJECT_NAME

    custom_resource_method :create_note,
                           http_verb: :post,
                           http_path: 'notes',
                           object_name: Helpscout::ConversationThread::OBJECT_NAME

    custom_resource_method :create_phone_thread,
                           http_verb: :post,
                           http_path: 'phones',
                           object_name: Helpscout::ConversationThread::OBJECT_NAME

    custom_resource_method :create_reply_thread,
                           http_verb: :post,
                           http_path: 'reply',
                           object_name: Helpscout::ConversationThread::OBJECT_NAME

    custom_resource_method :update_fields,
                           http_verb: :put,
                           http_path: 'fields'

    custom_resource_method :update_tags,
                           http_verb: :put,
                           http_path: 'tags'

    nested_resource_class_methods :attachment,
                                  operations: %i[delete],
                                  object_name: Helpscout::ConversationAttachment::OBJECT_NAME

    nested_resource_class_methods :thread,
                                  operations: %i[list update],
                                  object_name: Helpscout::ConversationThread::OBJECT_NAME

    def self.retrieve_attachment_data(conversation_id, attachment_id, opts = {})
      url = "/v2/conversations/#{conversation_id}/attachments/#{attachment_id}/data"
      resp, _opts = request(:get, url, {}, opts)
      Helpscout::Response.new(resp, object_name: Helpscout::ConversationAttachment::OBJECT_NAME)
    end

    def self.create_attachment(conversation_id, thread_id, params, opts = {})
      url = "/v2/conversations/#{conversation_id}/threads/#{thread_id}/attachments"
      resp, _opts = request(:post, url, params, opts)
      Helpscout::Response.new(resp, object_name: Helpscout::ConversationAttachment::OBJECT_NAME)
    end
  end
end
