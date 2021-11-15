# frozen_string_literal: true

require "byebug"
require "bundler/setup"
require "bonita"
require "support/faraday_helper"
require "resource_kit/testing"
require "support/shared_examples/error_handler_examples"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Bonita::FaradayHelper, type: :integration
  config.include Bonita::ErrorHandlerExamples, type: :integration
end
