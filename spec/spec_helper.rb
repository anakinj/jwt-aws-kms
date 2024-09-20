# frozen_string_literal: true

require "simplecov"

SimpleCov.start

require "jwt/kms"

Aws.config.update(
  endpoint: "http://localhost:4566",
  access_key_id: "test",
  secret_access_key: "test",
  region: "us-east-1"
)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
