# frozen_string_literal: true

RSpec.describe Jwt::KMS::Key do
  let(:key_id) do
    Aws::KMS::Client.new.create_key(key_spec: "HMAC_256", key_usage: "GENERATE_VERIFY_MAC").key_metadata.key_id
  end

  subject(:instance) { described_class.new(key_id: key_id) }

  describe "#sign" do
    subject(:signature) { instance.sign(**options) }

    let(:options) { { data: "payload" } }

    it "signs the data" do
      expect(signature).to be_a(String)
    end
  end
end
