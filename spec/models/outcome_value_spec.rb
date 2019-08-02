RSpec.describe OutcomeValue do
  let(:outcome) { FactoryBot.create(:outcome) }
  let(:answer) { FactoryBot.create(:answer) }

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
