# frozen_string_literal: true

RSpec.describe JWT::KMS do
  let(:algo_instance) { described_class.by(key_id: key_id) }
  let(:payload) { { "pay" => "load" } }

  describe "algorithm is given directly" do
    let(:key_id) { kms_key.key_metadata.key_id }

    context "when id to HMAC_256 key is given" do
      let(:kms_key) { Aws::KMS::Client.new.create_key(key_spec: "HMAC_256", key_usage: "GENERATE_VERIFY_MAC") }

      it "encodes and decodes" do
        token = JWT.encode(payload, nil, algo_instance)
        expect(JWT.decode(token, "Not relevant", true, algorithm: algo_instance))
          .to eq([payload, { "alg" => "HS256" }])
      end
    end

    context "when id to HMAC_384 key is given" do
      let(:kms_key) { Aws::KMS::Client.new.create_key(key_spec: "HMAC_384", key_usage: "GENERATE_VERIFY_MAC") }

      it "encodes and decodes" do
        token = JWT.encode(payload, nil, algo_instance)
        expect(JWT.decode(token, "Not relevant", true, algorithm: algo_instance))
          .to eq([payload, { "alg" => "HS384" }])
      end
    end

    context "when id to HMAC_512 key is given" do
      let(:kms_key) { Aws::KMS::Client.new.create_key(key_spec: "HMAC_512", key_usage: "GENERATE_VERIFY_MAC") }

      it "encodes and decodes" do
        token = JWT.encode(payload, nil, algo_instance)
        expect(JWT.decode(token, "Not relevant", true, algorithm: algo_instance))
          .to eq([payload, { "alg" => "HS512" }])
      end
    end
  end
end
