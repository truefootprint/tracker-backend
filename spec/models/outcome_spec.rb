RSpec.describe Outcome do
  describe "validations" do
    subject(:outcome) { FactoryBot.build(:outcome) }

    it "has a valid default factory" do
      expect(outcome).to be_valid
    end

    it "requires a name" do
      outcome.name = " "
      expect(outcome).to be_invalid
    end

    it "requires the higher_is_better boolean" do
      outcome.higher_is_better = nil
      expect(outcome).to be_invalid
    end

    it "requires a unit" do
      outcome.unit = nil
      expect(outcome).to be_invalid
    end
  end
end
