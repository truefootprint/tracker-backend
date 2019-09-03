class PageReference < ApplicationRecord
  belongs_to :answer

  def self.seed
    company = Company.find_by!(name: "Glencore")
    url = "https://www.glencore.com/dam:jcr/633f190c-76d6-42b3-beca-debb25134556/2018-Glencore-Sustainability-Report_.pdf"

    references = [
      ["Total energy use", 10],
    ]

    references.each do |question_text, page|
      question = Question.find_by!(text: question_text)
      answer = Answer.find_by!(question: question, company: company)

      PageReference.create!(answer: answer, url: url, page: page)
    end
  end
end
