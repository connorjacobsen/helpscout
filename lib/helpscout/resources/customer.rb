# frozen_string_literal: true

module Helpscout
  class Customer < Helpscout::Resource
    include Helpscout::API::Retrieve
    include Helpscout::API::List
    include Helpscout::API::Create
    include Helpscout::API::Update
    include Helpscout::API::NestedResource

    OBJECT_NAME = 'customer'

    custom_resource_method :create_address,
                           http_verb: :post,
                           http_path: 'address',
                           object_name: Helpscout::CustomerAddress::OBJECT_NAME

    custom_resource_method :update_address,
                           http_verb: :patch,
                           http_path: 'address',
                           object_name: Helpscout::CustomerAddress::OBJECT_NAME

    custom_resource_method :delete_address,
                           http_verb: :delete,
                           http_path: 'address',
                           object_name: Helpscout::CustomerAddress::OBJECT_NAME

    custom_resource_method :retrieve_address,
                           http_verb: :get,
                           http_path: 'address',
                           object_name: Helpscout::CustomerAddress::OBJECT_NAME

    nested_resource_class_methods :chat,
                                  operations: %i[create list update delete],
                                  object_name: Helpscout::CustomerChat::OBJECT_NAME

    nested_resource_class_methods :email,
                                  operations: %i[create list update delete],
                                  object_name: Helpscout::CustomerEmail::OBJECT_NAME

    nested_resource_class_methods :phone,
                                  operations: %i[create list update delete],
                                  object_name: Helpscout::CustomerPhone::OBJECT_NAME

    nested_resource_class_methods :social_profile,
                                  operations: %i[create list update delete],
                                  path: 'social-profiles',
                                  object_name: Helpscout::CustomerSocialProfile::OBJECT_NAME

    nested_resource_class_methods :website,
                                  operations: %i[create list update delete],
                                  object_name: Helpscout::CustomerWebsite::OBJECT_NAME
  end
end
