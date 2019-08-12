RSpec.describe CompanyRanking do
  describe "associations" do
    subject(:company_ranking) { FactoryBot.build(:company_ranking) }

    it "can optionally belong to a auditor" do
      expect(company_ranking.auditor).to be_nil
      expect(company_ranking).to be_valid

      company_ranking.auditor = FactoryBot.build(:company, name: "PwC")
      expect(company_ranking).to be_valid
    end
  end
end
