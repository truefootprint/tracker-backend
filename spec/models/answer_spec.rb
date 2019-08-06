RSpec.describe Answer do
  describe "associations" do
    subject(:answer) { FactoryBot.build(:answer) }

    it "can optionally belong to a verifier company" do
      expect(answer.verifier).to be_nil
      expect(answer).to be_valid

      answer.verifier = FactoryBot.build(:company, name: "PwC")
      expect(answer).to be_valid
    end
  end

  describe "validations" do
    subject(:answer) { FactoryBot.build(:answer) }

    it "is valid for the default factory" do
      expect(answer).to be_valid
    end

    it "requires a question" do
      answer.question = nil
      expect(answer).to be_invalid
    end

    it "requires a company" do
      answer.company = nil
      expect(answer).to be_invalid
    end

    it "requires a year" do
      answer.year = nil
      expect(answer).to be_invalid
    end

    it "requires a year between 1950 and 2050" do
      answer.year = 1949
      expect(answer).to be_invalid

      answer.year = 1950
      expect(answer).to be_valid

      answer.year = 2050
      expect(answer).to be_valid

      answer.year = 2051
      expect(answer).to be_invalid
    end

    it "requires a value" do
      answer.value = nil
      expect(answer).to be_invalid
    end

    it "requires a unique value per question/company/year" do
      existing = FactoryBot.create(:answer)

      answer.question = existing.question
      answer.company = existing.company
      answer.year = existing.year
      answer.unit = existing.unit

      expect(answer).to be_invalid

      answer.year += 1
      expect(answer).to be_valid
    end

    it "requires a unit" do
      answer.unit = nil
      expect(answer).to be_invalid
    end

    # TODO: make this more flexible so we can convert between units
    # it "requires a unit that matches the question's unit" do
    #   answer.unit = FactoryBot.build(:unit)
    #   expect(answer).to be_invalid
    # end
  end
end
