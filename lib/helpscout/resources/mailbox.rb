# frozen_string_literal: true

module Helpscout
  class Mailbox < Helpscout::Resource
    include Helpscout::API::List
    include Helpscout::API::Retrieve
    include Helpscout::API::NestedResource

    OBJECT_NAME = 'mailbox'

    # Override because it has a non-standard pluralization.
    def self.plural
      'mailboxes'
    end

    nested_resource_class_methods :folder,
                                  operations: %i[list],
                                  object_name: Helpscout::MailboxFolder::OBJECT_NAME

    nested_resource_class_methods :field,
                                  operations: %i[list],
                                  object_name: Helpscout::MailboxField::OBJECT_NAME
  end
end
