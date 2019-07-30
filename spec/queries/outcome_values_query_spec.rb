RSpec.describe OutcomeValuesQuery do
  subject(:query) { described_class.new }

  it "returns the values of the company answers for each outcome" do
    outcome = FactoryBot.create(:outcome)
    question = FactoryBot.create(:question)

    glencore = FactoryBot.create(:company)
    bhp = FactoryBot.create(:company)

    FactoryBot.create(:mapping, outcome: outcome, question: question)

    FactoryBot.create(:answer, question: question, company: glencore, year: 2017, value: 100)
    FactoryBot.create(:answer, question: question, company: glencore, year: 2018, value: 200)
    FactoryBot.create(:answer, question: question, company: bhp, year: 2017, value: 300)
    FactoryBot.create(:answer, question: question, company: bhp, year: 2018, value: 400)

    expect(query.results).to include(
      { outcome_id: outcome.id, company_id: glencore.id, year: 2017, value: 100 },
      { outcome_id: outcome.id, company_id: glencore.id, year: 2018, value: 200 },
      { outcome_id: outcome.id, company_id: bhp.id, year: 2017, value: 300 },
      { outcome_id: outcome.id, company_id: bhp.id, year: 2018, value: 400 },
    )
  end

  it "can divide answer values if the mapping has a divisor question" do
    outcome = FactoryBot.create(:outcome)

    question = FactoryBot.create(:question)
    divisor = FactoryBot.create(:question)

    glencore = FactoryBot.create(:company)
    bhp = FactoryBot.create(:company)

    FactoryBot.create(:mapping, outcome: outcome, question: question, divisor: divisor)

    FactoryBot.create(:answer, question: question, company: glencore, year: 2017, value: 100)
    FactoryBot.create(:answer, question: question, company: glencore, year: 2018, value: 200)
    FactoryBot.create(:answer, question: question, company: bhp, year: 2017, value: 300)
    FactoryBot.create(:answer, question: question, company: bhp, year: 2018, value: 400)

    FactoryBot.create(:answer, question: divisor, company: glencore, year: 2017, value: 2)
    FactoryBot.create(:answer, question: divisor, company: glencore, year: 2018, value: 4)
    FactoryBot.create(:answer, question: divisor, company: bhp, year: 2017, value: 5)
    FactoryBot.create(:answer, question: divisor, company: bhp, year: 2018, value: 10)

    expect(query.results).to include(
      { outcome_id: outcome.id, company_id: glencore.id, year: 2017, value: 100 / 2 },
      { outcome_id: outcome.id, company_id: glencore.id, year: 2018, value: 200 / 4 },
      { outcome_id: outcome.id, company_id: bhp.id, year: 2017, value: 300 / 5 },
      { outcome_id: outcome.id, company_id: bhp.id, year: 2018, value: 400 / 10 },
    )
  end
end
