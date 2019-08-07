RSpec.describe CompanyRankingsQuery do
  subject(:query) { described_class.new }

  let!(:sector) { FactoryBot.create(:sector) }

  let!(:company_1) { FactoryBot.create(:company, sector: sector) }
  let!(:company_2) { FactoryBot.create(:company, sector: sector) }

  let!(:outcome_1) { FactoryBot.create(:outcome) }
  let!(:outcome_2) { FactoryBot.create(:outcome) }

  let!(:question) { FactoryBot.create(:question) }

  before do
    # TODO extract a calendar_years table
    FactoryBot.create(:answer, question: question, company: company_1, year: 2017, value: 100)
    FactoryBot.create(:answer, question: question, company: company_2, year: 2017, value: 200)
    FactoryBot.create(:answer, question: question, company: company_2, year: 2018, value: 300)

    FactoryBot.create(:mapping, outcome: outcome_1, question: question)

    OutcomeValue.refresh
  end

  it "returns a row for every combination of company/outcome/year" do
    combinations = query.execute.group_by do |row|
      row.values_at(:company_id, :rankable_id, :year)
    end

    expect(combinations.keys).to match_array [
      [company_1.id, outcome_1.id, 2017],
      [company_1.id, outcome_1.id, 2018],
      [company_2.id, outcome_1.id, 2017],
      [company_2.id, outcome_1.id, 2018],
      [company_1.id, outcome_2.id, 2017],
      [company_1.id, outcome_2.id, 2018],
      [company_2.id, outcome_2.id, 2017],
      [company_2.id, outcome_2.id, 2018],
    ]
  end

  context "when an answer maps to the outcome" do
    let(:results) { query.execute }

    let(:first_answer) do
      results.detect do |row|
        row.values_at(:company_id, :rankable_id, :year) == [company_1.id, outcome_1.id, 2017]
      end
    end

    let(:second_answer) do
      results.detect do |row|
        row.values_at(:company_id, :rankable_id, :year) == [company_2.id, outcome_1.id, 2017]
      end
    end

    let(:third_answer) do
      results.detect do |row|
        row.values_at(:company_id, :rankable_id, :year) == [company_2.id, outcome_1.id, 2018]
      end
    end

    it "sets the value from the company's answer for the outcome" do
      expect(first_answer.fetch(:value)).to eq(100)
      expect(second_answer.fetch(:value)).to eq(200)
      expect(third_answer.fetch(:value)).to eq(300)
    end

    it "sets the count to 1" do
      expect(first_answer.fetch(:count)).to eq(1)
      expect(second_answer.fetch(:count)).to eq(1)
      expect(third_answer.fetch(:count)).to eq(1)
    end

    it "sets the rank by comparing company answers within outcome/year" do
      # These answers have the same outcome and year
      expect(first_answer.fetch(:rank)).to eq(1)
      expect(second_answer.fetch(:rank)).to eq(2)

      # This answer has a different year
      expect(third_answer.fetch(:rank)).to eq(1)
    end

    it "sets out_of to the number of companies ranked for the outcome" do
      expect(first_answer.fetch(:out_of)).to eq(2)
      expect(second_answer.fetch(:out_of)).to eq(2)

      expect(third_answer.fetch(:out_of)).to eq(1)
    end

    context "when higher_is_better is true" do
      before { outcome_1.update!(higher_is_better: true) }

      it "ranks in the opposite direction" do
        expect(first_answer.fetch(:rank)).to eq(2)
        expect(second_answer.fetch(:rank)).to eq(1)
      end
    end

    context "when the companies are in different sectors" do
      before { company_1.update!(sector: FactoryBot.create(:sector)) }

      it "ranks the companies independently by sector" do
        expect(first_answer.fetch(:rank)).to eq(1)
        expect(second_answer.fetch(:rank)).to eq(1)
      end
    end
  end

  context "when an answer does not map to the outcome" do
    let(:nil_answer) do
      query.execute.detect do |row|
        row.values_at(:company_id, :rankable_id, :year) == [company_1.id, outcome_1.id, 2018]
      end
    end

    it "sets the value to nil" do
      expect(nil_answer.fetch(:value)).to be_nil
    end

    it "sets the count to 0" do
      expect(nil_answer.fetch(:count)).to eq(0)
    end

    it "sets the rank to nil" do
      expect(nil_answer.fetch(:rank)).to be_nil
    end

    it "sets out_of to the number of companies ranked for the outcome" do
      expect(nil_answer.fetch(:out_of)).to eq(1)
    end
  end
end
