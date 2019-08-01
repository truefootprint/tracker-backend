RSpec.describe OutcomeValue do
  let(:outcome_1) { FactoryBot.create(:outcome) }
  let(:outcome_2) { FactoryBot.create(:outcome) }

  let(:company_1) { FactoryBot.create(:company) }
  let(:company_2) { FactoryBot.create(:company) }

  before do
    question_1 = FactoryBot.create(:question)
    question_2 = FactoryBot.create(:question)

    FactoryBot.create(:mapping, outcome: outcome_1, question: question_1)
    FactoryBot.create(:mapping, outcome: outcome_2, question: question_1, divisor: question_2)

    FactoryBot.create(:answer, question: question_1, company: company_1, year: 2017, value: 100)
    FactoryBot.create(:answer, question: question_1, company: company_1, year: 2018, value: 200)
    FactoryBot.create(:answer, question: question_1, company: company_2, year: 2017, value: 300)
    FactoryBot.create(:answer, question: question_1, company: company_2, year: 2018, value: 400)

    FactoryBot.create(:answer, question: question_2, company: company_1, year: 2017, value: 2)
    FactoryBot.create(:answer, question: question_2, company: company_1, year: 2018, value: 5)
    FactoryBot.create(:answer, question: question_2, company: company_2, year: 2017, value: 10)
    FactoryBot.create(:answer, question: question_2, company: company_2, year: 2018, value: 20)

    OutcomeValue.refresh
  end

  it "has a row for every company answer that maps to an outcome" do
    attributes = OutcomeValue.all.map(&:attributes)

    expect(attributes.map(&:symbolize_keys)).to include(
      { outcome_id: outcome_1.id, company_id: company_1.id, year: 2017, value: 100 },
      { outcome_id: outcome_1.id, company_id: company_1.id, year: 2018, value: 200 },
      { outcome_id: outcome_1.id, company_id: company_2.id, year: 2017, value: 300 },
      { outcome_id: outcome_1.id, company_id: company_2.id, year: 2018, value: 400 },

      { outcome_id: outcome_2.id, company_id: company_1.id, year: 2017, value: 50 },
      { outcome_id: outcome_2.id, company_id: company_1.id, year: 2018, value: 40 },
      { outcome_id: outcome_2.id, company_id: company_2.id, year: 2018, value: 20 },
      { outcome_id: outcome_2.id, company_id: company_2.id, year: 2017, value: 30 },
    )
  end

  it "does not add rows for divisions by zero" do
    Answer.last.update!(value: 0)
    OutcomeValue.refresh

    expect(OutcomeValue.count).to eq(7)
  end

  it "is readonly because it is backed by a materialized view" do
    expect { OutcomeValue.create!(outcome: outcome_1, company: company_1) }
      .to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it "must be manually refreshed before changes can be seen" do
    expect { Answer.last.destroy }.not_to change(OutcomeValue, :count)
    expect { OutcomeValue.refresh }.to change(OutcomeValue, :count).by(-1)
  end
end
