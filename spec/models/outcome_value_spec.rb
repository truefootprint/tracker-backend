RSpec.describe OutcomeValue do
  let(:outcome) { FactoryBot.create(:outcome) }
  let(:answer) { FactoryBot.create(:answer) }

  describe "associations" do
    subject(:outcome_value) { FactoryBot.build(:outcome_value) }

    it "can optionally belong to a auditor" do
      expect(outcome_value.auditor).to be_nil
      expect(outcome_value).to be_valid

      outcome_value.auditor = FactoryBot.build(:company, name: "PwC")
      expect(outcome_value).to be_valid
    end
  end

  it "is readonly because it is backed by a materialized view" do
    expect { OutcomeValue.create!(outcome: outcome, company: answer.company) }
      .to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it "must be manually refreshed before changes can be seen" do
    FactoryBot.create(:mapping, outcome: outcome, question: answer.question)

    expect { described_class.refresh }
      .to change(described_class, :count).from(0).to(1)
  end
end
