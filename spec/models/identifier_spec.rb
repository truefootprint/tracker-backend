RSpec.describe Identifier do
  describe "validations" do
    subject(:identifier) { FactoryBot.build(:identifier) }

    it "is valid for the default factory" do
      expect(identifier).to be_valid
    end

    it "requires a target" do
      identifier.target = nil
      expect(identifier).to be_invalid
    end

    it "requires a name" do
      identifier.name = " "
      expect(identifier).to be_invalid
    end

    it "requires a value" do
      identifier.value = " "
      expect(identifier).to be_invalid
    end

    it "requires a unique value per target/name" do
      existing = FactoryBot.create(:identifier)

      identifier.target = existing.target
      identifier.name = existing.name

      expect(identifier).to be_invalid

      identifier.name = "foo_id"
      expect(identifier).to be_valid
    end
  end
end
