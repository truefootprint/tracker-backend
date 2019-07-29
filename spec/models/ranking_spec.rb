RSpec.describe Ranking do
  describe "validations" do
    subject(:ranking) { FactoryBot.build(:ranking) }

    it "has a valid default factory" do
      expect(ranking).to be_valid
    end

    it "requires a target" do
      ranking.target = nil
      expect(ranking).to be_invalid
    end
  end
end
