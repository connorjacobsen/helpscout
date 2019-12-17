# frozen_string_literal: true

require 'bundler/setup'
require 'helpscout'

require File.join(File.dirname(__FILE__), 'support', 'response_loader')

# Shared Example groups.
require File.join(File.dirname(__FILE__), 'shared', 'retrievable')
require File.join(File.dirname(__FILE__), 'shared', 'listable')
require File.join(File.dirname(__FILE__), 'shared', 'creatable')
require File.join(File.dirname(__FILE__), 'shared', 'updatable')
require File.join(File.dirname(__FILE__), 'shared', 'deletable')
require File.join(File.dirname(__FILE__), 'shared', 'nested_listable')
require File.join(File.dirname(__FILE__), 'shared', 'nested_creatable')
require File.join(File.dirname(__FILE__), 'shared', 'nested_updatable')
require File.join(File.dirname(__FILE__), 'shared', 'nested_deletable')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
