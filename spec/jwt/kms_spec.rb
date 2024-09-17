# frozen_string_literal: true

RSpec.describe JWT::KMS do
  let(:key_id) do
    Aws::KMS::Client.new.create_key(key_spec: "HMAC_256", key_usage: "GENERATE_VERIFY_MAC").key_metadata.key_id
  end

  let(:algo_instance) do
    described_class::Key.by(key_id: key_id)
  end

  let(:payload) { { "pay" => "load" } }

  describe "encoding and decoding" do
    context "when encoding and decoding keys match" do
      it "executes successfully" do
        token = JWT.encode(payload, nil, algo_instance)
        expect(JWT.decode(token, "Not relevant", true, algorithm: algo_instance))
          .to eq([payload, { "alg" => "HS256" }])
      end
    end
  end
end
