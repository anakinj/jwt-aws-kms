# frozen_string_literal: true

module JWT
  module KMS
    # :nodoc:
    class Key
      def self.by(key_id:)
        new(key_id: key_id)
      end

      include JWT::JWA::SigningAlgorithm

      def initialize(key_id:)
        @key_id = key_id
        @alg = "HS256"
      end

      def header(*)
        { "alg" => "HS256" }
      end

      def sign(data:, **)
        client.generate_mac(key_id: key_id, mac_algorithm: "HMAC_SHA_256", message: data).mac
      end

      def verify(data:, signature:, **)
        client.verify_mac(key_id: key_id, mac_algorithm: "HMAC_SHA_256", message: data, mac: signature).mac_valid
      end

      private

      attr_reader :key_id

      def client
        @client = Aws::KMS::Client.new
      end
    end
  end
end
