# frozen_string_literal: true

module JWT
  module KMS
    # Represent a AWS HMAC key
    # https://docs.aws.amazon.com/kms/latest/developerguide/hmac.html
    class HmacKey
      include JWT::JWA::SigningAlgorithm

      MAPPINGS = {
        "HMAC_256" => { alg: "HS256", mac_algorithm: "HMAC_SHA_256" },
        "HMAC_384" => { alg: "HS384", mac_algorithm: "HMAC_SHA_384" },
        "HMAC_512" => { alg: "HS512", mac_algorithm: "HMAC_SHA_512" }
      }.freeze

      def initialize(key_id:, key_spec: nil)
        @key_id = key_id
        @key_spec = key_spec
      end

      def alg
        MAPPINGS.dig(key_spec, :alg)
      end

      def sign(data:, **)
        KMS.client.generate_mac(key_id: key_id, mac_algorithm: mac_algorithm, message: data).mac
      end

      def verify(data:, signature:, **)
        KMS.client.verify_mac(key_id: key_id, mac_algorithm: mac_algorithm, message: data, mac: signature).mac_valid
      end

      private

      attr_reader :key_id

      def key_spec
        @key_spec ||= description.key_spec
      end

      def mac_algorithm
        MAPPINGS.dig(key_spec, :mac_algorithm)
      end

      def description
        @description ||= KMS.client.describe_key(key_id: key_id)
      end
    end
  end
end
