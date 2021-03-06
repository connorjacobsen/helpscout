# frozen_string_literal: true

module HelpScout
  class Customer < HelpScout::Resource
    include HelpScout::API::Retrieve
    include HelpScout::API::List
    include HelpScout::API::Create
    include HelpScout::API::Update
    include HelpScout::API::NestedResource

    OBJECT_NAME = 'customer'

    # Customer resource uses `PUT` as the HTTP verb.
    def self.update_verb
      :put
    end

    custom_resource_method :create_address,
                           http_verb: :post,
                           http_path: 'address',
                           object_name: HelpScout::CustomerAddress::OBJECT_NAME

    custom_resource_method :update_address,
                           http_verb: :patch,
                           http_path: 'address',
                           object_name: HelpScout::CustomerAddress::OBJECT_NAME

    custom_resource_method :delete_address,
                           http_verb: :delete,
                           http_path: 'address',
                           object_name: HelpScout::CustomerAddress::OBJECT_NAME

    custom_resource_method :retrieve_address,
                           http_verb: :get,
                           http_path: 'address',
                           object_name: HelpScout::CustomerAddress::OBJECT_NAME

    nested_resource_class_methods :chat,
                                  operations: %i[create list update delete],
                                  object_name: HelpScout::CustomerChat::OBJECT_NAME

    nested_resource_class_methods :email,
                                  operations: %i[create list update delete],
                                  object_name: HelpScout::CustomerEmail::OBJECT_NAME

    nested_resource_class_methods :phone,
                                  operations: %i[create list update delete],
                                  object_name: HelpScout::CustomerPhone::OBJECT_NAME

    nested_resource_class_methods :social_profile,
                                  operations: %i[create list update delete],
                                  path: 'social-profiles',
                                  object_name: HelpScout::CustomerSocialProfile::OBJECT_NAME

    nested_resource_class_methods :website,
                                  operations: %i[create list update delete],
                                  object_name: HelpScout::CustomerWebsite::OBJECT_NAME
  end
end
