RSpec.describe Mapping do
  describe "associations" do
    subject(:mapping) { FactoryBot.build(:mapping) }

    it "can optionally have a divisor question" do
      expect(mapping.divisor).to be_nil
      expect(mapping).to be_valid

      mapping.divisor = FactoryBot.build(:question)
      expect(mapping).to be_valid
    end
  end

  describe "validations" do
    subject(:mapping) { FactoryBot.build(:mapping) }

    it "is valid for the default factory" do
      expect(mapping).to be_valid
    end

    it "requires an outcome" do
      mapping.outcome = nil
      expect(mapping).to be_invalid
    end

    it "requires a question" do
      mapping.question = nil
      expect(mapping).to be_invalid
    end
  end
end
