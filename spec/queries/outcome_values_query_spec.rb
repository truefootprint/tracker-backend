RSpec.describe OutcomeValuesQuery do
  subject(:query) { described_class.new }

  let(:outcome_1) { FactoryBot.create(:outcome) }
  let(:outcome_2) { FactoryBot.create(:outcome) }

  let(:company_1) { FactoryBot.create(:company) }
  let(:company_2) { FactoryBot.create(:company) }

  let(:auditor_1) { FactoryBot.create(:company) }
  let(:auditor_2) { FactoryBot.create(:company) }

  before do
    question_1 = FactoryBot.create(:question)
    question_2 = FactoryBot.create(:question)

    FactoryBot.create(:mapping, outcome: outcome_1, question: question_1)
    FactoryBot.create(:mapping, outcome: outcome_2, question: question_1, divisor: question_2)

    FactoryBot.create(:answer, question: question_1, company: company_1, year: 2017, value: 100, auditor: auditor_1)
    FactoryBot.create(:answer, question: question_1, company: company_1, year: 2018, value: 200, auditor: auditor_1)
    FactoryBot.create(:answer, question: question_1, company: company_2, year: 2017, value: 300)
    FactoryBot.create(:answer, question: question_1, company: company_2, year: 2018, value: 400)

    FactoryBot.create(:answer, question: question_2, company: company_1, year: 2017, value: 2, auditor: auditor_2)
    FactoryBot.create(:answer, question: question_2, company: company_1, year: 2018, value: 5)
    FactoryBot.create(:answer, question: question_2, company: company_2, year: 2017, value: 10)
    FactoryBot.create(:answer, question: question_2, company: company_2, year: 2018, value: 20)
  end

  it "returns a list of company answers that have been mapped to outcomes" do
    expect(query.execute).to include(
      { outcome_id: outcome_1.id, company_id: company_1.id, year: 2017, value: 100, auditor_id: auditor_1.id },
      { outcome_id: outcome_1.id, company_id: company_1.id, year: 2018, value: 200, auditor_id: auditor_1.id },
      { outcome_id: outcome_1.id, company_id: company_2.id, year: 2017, value: 300, auditor_id: nil },
      { outcome_id: outcome_1.id, company_id: company_2.id, year: 2018, value: 400, auditor_id: nil },

      { outcome_id: outcome_2.id, company_id: company_1.id, year: 2017, value: 50, auditor_id: auditor_1.id },
      { outcome_id: outcome_2.id, company_id: company_1.id, year: 2018, value: 40, auditor_id: nil },
      { outcome_id: outcome_2.id, company_id: company_2.id, year: 2018, value: 20, auditor_id: nil },
      { outcome_id: outcome_2.id, company_id: company_2.id, year: 2017, value: 30, auditor_id: nil },
    )
  end

  it "does not return rows where there would be a division by zero" do
    Answer.last.update!(value: 0)

    expect(query.execute.size).to eq(7)
  end
end
