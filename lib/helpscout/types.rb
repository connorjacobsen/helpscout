# frozen_string_literal: true

# frozen_string_literal

module Helpscout
  module Types
    OBJECT_TYPES = {
      Customer::OBJECT_NAME => Customer,
      CustomerAddress::OBJECT_NAME => CustomerAddress,
      CustomerChat::OBJECT_NAME => CustomerChat,
      CustomerEmail::OBJECT_NAME => CustomerEmail,
      CustomerPhone::OBJECT_NAME => CustomerPhone,
      CustomerSocialProfile::OBJECT_NAME => CustomerSocialProfile,
      CustomerWebsite::OBJECT_NAME => CustomerWebsite,
      Conversation::OBJECT_NAME => Conversation,
      ConversationThread::OBJECT_NAME => ConversationThread,
      Mailbox::OBJECT_NAME => Mailbox,
      MailboxField::OBJECT_NAME => MailboxField,
      MailboxFolder::OBJECT_NAME => MailboxFolder,
      Rating::OBJECT_NAME => Rating,
      Tag::OBJECT_NAME => Tag,
      Team::OBJECT_NAME => Team,
      User::OBJECT_NAME => User,
      Webhook::OBJECT_NAME => Webhook,
      Workflow::OBJECT_NAME => Workflow
    }.freeze

    def self.object_names_to_classes
      OBJECT_TYPES
    end

    def self.object_by_name(name)
      OBJECT_TYPES[name]
    end
  end
end
