# frozen_string_literal: true

require "aws-sdk-kms"
require "jwt"

require_relative "kms/version"
require_relative "kms/hmac_key"

module JWT
  # :nodoc:
  module KMS
    def self.client
      @client ||= Aws::KMS::Client.new
    end

    def self.by(key_id:)
      from_description(KMS.client.describe_key(key_id: key_id))
    end

    def self.from_description(description)
      case description.key_metadata.key_usage
      when "GENERATE_VERIFY_MAC"
        HmacKey.new(key_id: description.key_metadata.key_id, key_spec: description.key_metadata.key_spec)
      when "SIGN_VERIFY"
        SignVerifyKey.new(key_id: description.key_metadata.key_id, key_spec: description.key_metadata.key_spec)
      else
        raise ArgumentError, "Keys with key_usage #{description.key_metadata.key_usage} not supported"
      end
    end
  end
end
