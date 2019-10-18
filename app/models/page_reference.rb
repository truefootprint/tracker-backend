class PageReference < ApplicationRecord
  belongs_to :answer

  def self.seed(sector_name)
    if sector_name == "mining"
      seed_mining
    elsif sector_name == "fashion"
      seed_fashion
    end
  end

  def self.seed_mining
    company = Company.find_by(name: "Gold Fields")
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

  def self.seed_fashion
    company = Company.find_by(name: "Inditex")
    url = "https://www.inditex.com/documents/10279/619384/Inditex+Annual+Report+2018.pdf/a0bd86be-36d4-fe30-0ceb-3ab45bd7bced"

    references = [
      [20,  "Total revenue (in million $)"],
      [274, "Total production (in million items of clothing)"],
      [286, "Total GHG emissions (scope 1  and 2)"],
      [283, "Total energy use"],
      [176, "Percentage of electricity from renewable sources"],
      [423, "Significant environmental incidents (spills)"],
      [419, "Employee turnover rate"],
      [249, "Percentage of board members who are female"],
      [79,  "Gender pay gap"],
      [429, "Confirmed incidents of corruption"],
      [428, "Legal actions for anti-competitive behaviour, anti-trust and monopoly practices"],
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
