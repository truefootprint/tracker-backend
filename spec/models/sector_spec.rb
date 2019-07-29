RSpec.describe Sector do
  describe "validations" do
    subject(:sector) { FactoryBot.build(:sector) }

    it "is valid for the default factory" do
      expect(sector).to be_valid
    end

    it "requires a name" do
      sector.name = " "
      expect(sector).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:sector, name: "Mining")

      sector.name = "mining"
      expect(sector).to be_invalid
    end
  end
end
