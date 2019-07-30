RSpec.describe CompanyRanking do
  subject(:ranking) { described_class.new(outcome, 2018) }

  let(:outcome) { FactoryBot.create(:outcome) }
  let(:question) { FactoryBot.create(:question) }

  let(:company_1) { FactoryBot.create(:company, name: "Company 1") }
  let(:company_2) { FactoryBot.create(:company, name: "Company 2") }

  before do
    FactoryBot.create(:mapping, outcome: outcome, question: question)

    FactoryBot.create(:answer, question: question, company: company_1, year: 2018, value: 200)
    FactoryBot.create(:answer, question: question, company: company_2, year: 2018, value: 100)

    OutcomeValue.refresh
  end

  it "ranks companies by their outcome values" do
    expect(ranking.map(&:name)).to eq ["Company 2", "Company 1"]
    expect(ranking.map(&:value)).to eq [100, 200]
    expect(ranking.map(&:rank)).to eq [1, 2]
  end

  it "ranks the other way if higher_is_better for the outcome" do
    outcome.update!(higher_is_better: true)

    expect(ranking.map(&:name)).to eq ["Company 1", "Company 2"]
    expect(ranking.map(&:value)).to eq [200, 100]
    expect(ranking.map(&:rank)).to eq [1, 2]
  end

  it "handles ties correctly" do
    company_3 = FactoryBot.create(:company, name: "Company 3")

    FactoryBot.create(:answer, question: question, company: company_3, year: 2018, value: 100)

    OutcomeValue.refresh

    expect(ranking.map(&:name)).to eq ["Company 3", "Company 2", "Company 1"]
    expect(ranking.map(&:value)).to eq [100, 100, 200]
    expect(ranking.map(&:rank)).to eq [1, 1, 3]
  end
end
