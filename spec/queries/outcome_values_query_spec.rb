RSpec.describe OutcomeValuesQuery do
  subject(:query) { described_class.new }

  let!(:outcome) { FactoryBot.create(:outcome) }
  let!(:question) { FactoryBot.create(:question) }

  let!(:mapping) { FactoryBot.create(:mapping, outcome: outcome, question: question) }

  let!(:glencore) { FactoryBot.create(:company) }
  let!(:bhp) { FactoryBot.create(:company) }

  before do
    FactoryBot.create(:answer, question: question, company: glencore, year: 2017, value: 100)
    FactoryBot.create(:answer, question: question, company: glencore, year: 2018, value: 200)
    FactoryBot.create(:answer, question: question, company: bhp, year: 2017, value: 300)
    FactoryBot.create(:answer, question: question, company: bhp, year: 2018, value: 400)
  end

  it "returns the values of the company answers for each outcome" do
    expect(query.results).to include(
      { outcome_id: outcome.id, year: 2017, company_id: glencore.id, value: 100 },
      { outcome_id: outcome.id, year: 2018, company_id: glencore.id, value: 200 },
      { outcome_id: outcome.id, year: 2017, company_id: bhp.id, value: 300 },
      { outcome_id: outcome.id, year: 2018, company_id: bhp.id, value: 400 },
    )
  end

  it "can divide answer values if the mapping has a divisor question" do
    divisor = FactoryBot.create(:question)
    mapping.update!(divisor: divisor)

    FactoryBot.create(:answer, question: divisor, company: glencore, year: 2017, value: 2)
    FactoryBot.create(:answer, question: divisor, company: glencore, year: 2018, value: 4)
    FactoryBot.create(:answer, question: divisor, company: bhp, year: 2017, value: 5)
    FactoryBot.create(:answer, question: divisor, company: bhp, year: 2018, value: 10)

    expect(query.results).to include(
      { outcome_id: outcome.id, year: 2017, company_id: glencore.id, value: 100 / 2 },
      { outcome_id: outcome.id, year: 2018, company_id: glencore.id, value: 200 / 4 },
      { outcome_id: outcome.id, year: 2017, company_id: bhp.id, value: 300 / 5 },
      { outcome_id: outcome.id, year: 2018, company_id: bhp.id, value: 400 / 10 },
    )
  end

  context "when the order option is specified" do
    subject(:query) { described_class.new(ordered: true) }

    it "orders the results by outcome/year and whether higher_is_better for the outcome" do
      outcome.update!(higher_is_better: true)

      expect(query.results).to eq [
        { outcome_id: outcome.id, year: 2017, company_id: bhp.id, value: 300 },
        { outcome_id: outcome.id, year: 2017, company_id: glencore.id, value: 100 },
        { outcome_id: outcome.id, year: 2018, company_id: bhp.id, value: 400 },
        { outcome_id: outcome.id, year: 2018, company_id: glencore.id, value: 200 },
      ]

      outcome.update!(higher_is_better: false)

      expect(query.results).to eq [
        { outcome_id: outcome.id, year: 2017, company_id: glencore.id, value: 100 },
        { outcome_id: outcome.id, year: 2017, company_id: bhp.id, value: 300 },
        { outcome_id: outcome.id, year: 2018, company_id: glencore.id, value: 200 },
        { outcome_id: outcome.id, year: 2018, company_id: bhp.id, value: 400 },
      ]
    end
  end
end
