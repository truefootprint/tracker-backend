RSpec.describe Company do
  describe "validations" do
    subject(:company) { FactoryBot.build(:company) }

    it "is valid for the default factory" do
      expect(company).to be_valid
    end

    it "requires a name" do
      company.name = " "
      expect(company).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:company, name: "Glencore")

      company.name = "glencore"
      expect(company).to be_invalid
    end

    it "requires a sector" do
      company.sector = nil
      expect(company).to be_invalid
    end
  end
end
