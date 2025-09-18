# spec/normalizer_spec.rb
# frozen_string_literal: true
require_relative "../lib/normalizer"

RSpec.describe Normalizer do
  context "strict mode validation" do
    let(:normalizer) { described_class.new(strict: true) }

    it "does NOT raise when required fields are present and non-empty" do
      row = { name: "A", category: "herbivore", period: "C", diet: "plants", age: 7 }
      expect { normalizer.call(row) }.not_to raise_error
    end

    it "raises when a required field is nil" do
      row = { name: nil, category: "herbivore", period: "C", diet: "plants", age: 7 }
      expect { normalizer.call(row) }.to raise_error(ArgumentError, /Missing required field: name/)
    end

    it "raises when a required field is an empty string" do
      row = { name: "", category: "herbivore", period: "C", diet: "plants", age: 7 }
      expect { normalizer.call(row) }.to raise_error(ArgumentError, /Missing required field: name/)
    end
  end

  context "non-strict mode" do
    let(:normalizer) { described_class.new(strict: false) }

    it "does not raise on missing required fields (lenient)" do
      row = { name: "", category: nil, period: "C", diet: nil, age: "not-a-number" }
      n = nil
      expect { n = normalizer.call(row) }.not_to raise_error
      expect(n[:age]).to eq(0)                 # coercion still works
      expect(n[:name]).to eq("")               # passes through when not strict
      expect(n[:category]).to be_nil
      expect(n[:diet]).to be_nil
    end
  end
end