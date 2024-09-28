# frozen_string_literal: true

RSpec.describe JWT::Aws::KMS do
  let(:payload) { { "pay" => "load" } }

  describe ".for" do
    subject(:algo_instance) { described_class.for(algorithm: key_algorithm) }

    let(:key_id) { kms_key.key_metadata.key_id }
    let(:key_algorithm) { nil }

    shared_examples "a AWS KMS algorithm" do |key_spec, key_usage, key_algorithm|
      let(:key_algorithm) { key_algorithm }
      let(:kms_key) { Aws::KMS::Client.new.create_key(key_spec: key_spec, key_usage: key_usage) }

      it "encodes and decodes as #{key_algorithm}" do
        token = JWT.encode(payload, key_id, algo_instance)
        expect(JWT.decode(token, key_id, true, algorithm: algo_instance))
          .to eq([payload, { "alg" => key_algorithm }])
      end
    end

    context "when key_id is referring a HMAC_256 key" do
      it_behaves_like "a AWS KMS algorithm", "HMAC_256", "GENERATE_VERIFY_MAC", "HS256"
    end

    context "when key_id is referring a HMAC_384 key" do
      it_behaves_like "a AWS KMS algorithm", "HMAC_384", "GENERATE_VERIFY_MAC", "HS384"
    end

    context "when key_id is referring a HMAC_512 key" do
      it_behaves_like "a AWS KMS algorithm", "HMAC_512", "GENERATE_VERIFY_MAC", "HS512"
    end

    context "when key_id is referring a RSA_2048 key" do
      it_behaves_like "a AWS KMS algorithm", "RSA_2048", "SIGN_VERIFY", "RS256"
      it_behaves_like "a AWS KMS algorithm", "RSA_2048", "SIGN_VERIFY", "RS384"
      it_behaves_like "a AWS KMS algorithm", "RSA_2048", "SIGN_VERIFY", "RS512"

      it_behaves_like "a AWS KMS algorithm", "RSA_2048", "SIGN_VERIFY", "PS256"
      it_behaves_like "a AWS KMS algorithm", "RSA_2048", "SIGN_VERIFY", "PS384"
      it_behaves_like "a AWS KMS algorithm", "RSA_2048", "SIGN_VERIFY", "PS512"
    end

    context "when key_id is referring a RSA_3072 key" do
      it_behaves_like "a AWS KMS algorithm", "RSA_3072", "SIGN_VERIFY", "RS256"
      it_behaves_like "a AWS KMS algorithm", "RSA_3072", "SIGN_VERIFY", "RS384"
      it_behaves_like "a AWS KMS algorithm", "RSA_3072", "SIGN_VERIFY", "RS512"

      it_behaves_like "a AWS KMS algorithm", "RSA_3072", "SIGN_VERIFY", "PS256"
      it_behaves_like "a AWS KMS algorithm", "RSA_3072", "SIGN_VERIFY", "PS384"
      it_behaves_like "a AWS KMS algorithm", "RSA_3072", "SIGN_VERIFY", "PS512"
    end

    context "when key_id is referring a RSA_4096 key" do
      it_behaves_like "a AWS KMS algorithm", "RSA_4096", "SIGN_VERIFY", "RS256"
      it_behaves_like "a AWS KMS algorithm", "RSA_4096", "SIGN_VERIFY", "RS384"
      it_behaves_like "a AWS KMS algorithm", "RSA_4096", "SIGN_VERIFY", "RS512"

      it_behaves_like "a AWS KMS algorithm", "RSA_4096", "SIGN_VERIFY", "PS256"
      it_behaves_like "a AWS KMS algorithm", "RSA_4096", "SIGN_VERIFY", "PS384"
      it_behaves_like "a AWS KMS algorithm", "RSA_4096", "SIGN_VERIFY", "PS512"
    end

    context "when key_id is referring a ECC_NIST_P256 key" do
      it_behaves_like "a AWS KMS algorithm", "ECC_NIST_P256", "SIGN_VERIFY", "ES256"
    end

    context "when key_id is referring a ECC_NIST_P384 key" do
      it_behaves_like "a AWS KMS algorithm", "ECC_NIST_P384", "SIGN_VERIFY", "ES384"
    end

    context "when key_id is referring a ECC_NIST_P521 key" do
      it_behaves_like "a AWS KMS algorithm", "ECC_NIST_P521", "SIGN_VERIFY", "ES512"
    end

    context "when algorithm is not supported" do
      let(:key_algorithm) { "HS666" }

      it "raises an ArgumentError" do
        expect { algo_instance }.to raise_error(ArgumentError)
      end
    end

    context "when algorithm key is not found" do
      let(:key_algorithm) { "HS256" }

      it "raises native AWS component error" do
        expect { JWT.encode(payload, "not-found", algo_instance) }.to raise_error(Aws::KMS::Errors::NotFoundException)
      end
    end
  end

  describe "readme example" do
    it "works as documented" do
      key = Aws::KMS::Client.new.create_key(key_spec: "HMAC_512", key_usage: "GENERATE_VERIFY_MAC")

      algo = described_class.for(algorithm: "HS512")

      token = JWT.encode(payload, key.key_metadata.key_id, algo)
      decoded_token = JWT.decode(token, key.key_metadata.key_id, true, algorithm: algo)

      expect(decoded_token).to eq([{ "pay" => "load" }, { "alg" => "HS512" }])
    end
  end
end
