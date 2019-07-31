RSpec.describe Group do
  describe "validations" do
    subject(:group) { FactoryBot.build(:group) }

    it "has a valid default factory" do
      expect(group).to be_valid
    end

    it "requires a name" do
      group.name = " "
      expect(group).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:group, name: "ESG")

      group.name = "esg"
      expect(group).to be_invalid
    end
  end
end
