RSpec.describe GroupWeight do
  describe "validations" do
    subject(:group_weight) { FactoryBot.build(:group_weight) }

    it "has a valid default factory" do
      expect(group_weight).to be_valid
    end

    it "requires a name" do
      group_weight.name = " "
      expect(group_weight).to be_invalid
    end

    it "requires a group" do
      group_weight.group = nil
      expect(group_weight).to be_invalid
    end

    it "requires a weight" do
      group_weight.weight = nil
      expect(group_weight).to be_invalid
    end
  end
end
