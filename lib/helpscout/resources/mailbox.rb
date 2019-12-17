# frozen_string_literal: true

module HelpScout
  class Mailbox < HelpScout::Resource
    include HelpScout::API::List
    include HelpScout::API::Retrieve
    include HelpScout::API::NestedResource

    OBJECT_NAME = 'mailbox'

    # Override because it has a non-standard pluralization.
    def self.plural
      'mailboxes'
    end

    nested_resource_class_methods :folder,
                                  operations: %i[list],
                                  object_name: HelpScout::MailboxFolder::OBJECT_NAME

    nested_resource_class_methods :field,
                                  operations: %i[list],
                                  object_name: HelpScout::MailboxField::OBJECT_NAME
  end
end
