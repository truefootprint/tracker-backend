class PageReference < ApplicationRecord
  belongs_to :answer

  def self.seed
    company = Company.find_by!(name: "Gold Fields")
    url = "https://www.goldfields.com/pdf/investors/integrated-annual-reports/2018/iar-2018.pdf"

    references = [
      [91,  "Total revenue (in million $)"],
      [133, "Total production (in tonnes)"],
      [99,  "Total GHG emissions (scope 1  and 2)"],
      [133, "Total energy use"],
      [133, "Total water use"],
      [6,   "Percentage of water recycled"],
      [133, "Significant environmental incidents (spills)"],
      [133, "Lost time injury frequency rate (LTIFR)"],
      [133, "Number of employee fatalities"],
      [78,  "Entry level wage as a percentage of local minimum wage"],
      [94,  "Percentage of in-country procurement"],
      [78,  "Gender pay gap"],
    ]

    references.each do |page, question_text|
      question = Question.find_by!(text: question_text)
      answers = Answer.where(question: question, company: company)

      answers.each do |answer|
        PageReference.create!(answer: answer, url: url, page: page)
      end
    end
  end
end
