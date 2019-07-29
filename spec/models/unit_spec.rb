RSpec.describe Unit do
  describe "validations" do
    subject(:unit) { FactoryBot.build(:unit) }

    it "is valid for the default factory" do
      expect(unit).to be_valid
    end

    it "requires a name" do
      unit.name = " "
      expect(unit).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:unit, name: "Metres")

      unit.name = "metres"
      expect(unit).to be_invalid
    end
  end
end
