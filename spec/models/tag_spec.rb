RSpec.describe Tag do
  describe "validations" do
    subject(:tag) { FactoryBot.build(:tag) }

    it "is valid for the default factory" do
      expect(tag).to be_valid
    end

    it "requires a target" do
      tag.target = nil
      expect(tag).to be_invalid
    end

    it "requires a name" do
      tag.name = " "
      expect(tag).to be_invalid
    end

    it "requires a unique target/name" do
      existing = FactoryBot.create(:tag, name: "Gold")

      tag.target = existing.target
      tag.name = "gold"

      expect(tag).to be_invalid
    end
  end
end
