# frozen_string_literal: true

module JWT
  module Aws
    module KMS
      # Represent a AWS asymmetric key
      # https://docs.aws.amazon.com/kms/latest/developerguide/symmetric-asymmetric.html
      class SignVerifyKey
        include JWT::JWA::SigningAlgorithm

        MAPPINGS = {
          "RS256" => "RSASSA_PKCS1_V1_5_SHA_256",
          "RS384" => "RSASSA_PKCS1_V1_5_SHA_384",
          "RS512" => "RSASSA_PKCS1_V1_5_SHA_512",
          "PS256" => "RSASSA_PSS_SHA_256",
          "PS384" => "RSASSA_PSS_SHA_384",
          "PS512" => "RSASSA_PSS_SHA_512",
          "ES256" => "ECDSA_SHA_256",
          "ES384" => "ECDSA_SHA_384",
          "ES512" => "ECDSA_SHA_512"
        }.freeze

        def initialize(algorithm:)
          @alg = algorithm
        end

        def sign(data:, signing_key:, **)
          KMS.client.sign(key_id: signing_key, signing_algorithm: signing_algorithm,
                          message: data).signature
        end

        def verify(data:, verification_key:, signature:, **)
          KMS.client.verify(key_id: verification_key, signing_algorithm: signing_algorithm,
                            message: data, signature: signature).signature_valid
        end

        private

        attr_reader :key_id

        def signing_algorithm
          MAPPINGS.fetch(alg, nil)
        end
      end
    end
  end
end
