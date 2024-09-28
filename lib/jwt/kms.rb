# frozen_string_literal: true

require "aws-sdk-kms"
require "jwt"

require_relative "kms/version"
require_relative "kms/hmac_key"
require_relative "kms/sign_verify_key"

module JWT
  # :nodoc:
  module KMS
    def self.client
      @client ||= Aws::KMS::Client.new
    end

    def self.for(algorithm:)
      if HmacKey::MAPPINGS.key?(algorithm)
        HmacKey
      elsif SignVerifyKey::MAPPINGS.key?(algorithm)
        SignVerifyKey
      else
        raise ArgumentError, "Algorithm #{algorithm} not supported"
      end.new(algorithm: algorithm)
    end
  end
end
