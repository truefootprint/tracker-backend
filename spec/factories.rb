FactoryBot.define do
  factory :sector do
    sequence(:name) { |n| "Sector #{n}" }
  end

  factory :company do
    sequence(:name) { |n| "Company #{n}" }
    sector
  end

  factory :question do
    sequence(:gri_code) { |n| "GRI 100-#{n}" }
    sequence(:text) { |n| "What is the answer to question #{n}?" }
  end

  factory :answer do
    question
    company
    year { Time.now.year }
    value { 123 }
    #unit
  end
end
