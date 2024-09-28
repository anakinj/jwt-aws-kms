# frozen_string_literal: true

module JWT
  module KMS
    # Represent a AWS HMAC key
    # https://docs.aws.amazon.com/kms/latest/developerguide/hmac.html
    class HmacKey
      include JWT::JWA::SigningAlgorithm

      MAPPINGS = {
        "HS256" => "HMAC_SHA_256",
        "HS384" => "HMAC_SHA_384",
        "HS512" => "HMAC_SHA_512"
      }.freeze

      def initialize(algorithm:)
        @alg = algorithm
      end

      def sign(data:, signing_key:, **)
        KMS.client.generate_mac(key_id: signing_key, mac_algorithm: mac_algorithm, message: data).mac
      end

      def verify(data:, verification_key:, signature:, **)
        KMS.client.verify_mac(key_id: verification_key, mac_algorithm: mac_algorithm, message: data,
                              mac: signature).mac_valid
      end

      private

      attr_reader :key_id

      def mac_algorithm
        MAPPINGS.fetch(alg, nil)
      end
    end
  end
end
