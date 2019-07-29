RSpec.describe Question do
  describe "validations" do
    subject(:question) { FactoryBot.build(:question) }

    it "is valid for the default factory" do
      expect(question).to be_valid
    end

    it "requires text" do
      question.text = " "
      expect(question).to be_invalid
    end

    it "requires unique text" do
      FactoryBot.create(:question, text: "Total water use?")

      question.text = "total water use?"
      expect(question).to be_invalid
    end

    it "require a unit" do
      question.unit = nil
      expect(question).to be_invalid
    end
  end
end
