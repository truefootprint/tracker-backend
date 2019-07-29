FactoryBot.define do
  factory :sector do
    sequence(:name) { |n| "Sector #{n}" }
  end

  factory :company do
    sequence(:name) { |n| "Company #{n}" }
    sector
  end

  factory :question do
    sequence(:text) { |n| "What is the answer to question #{n}?" }
    unit
  end

  factory :answer do
    question
    company
    year { Time.now.year }
    value { 123 }
    unit { question.unit }
  end

  factory :unit do
    sequence(:name) { |n| "Unit #{n}" }
  end

  factory :identifier do
    association :target, factory: :question
    name { :gri_code }
    value { "GRI 123-1" }
  end

  factory :outcome do
    sequence(:name) { |n| "Outcome #{n}" }
    higher_is_better { true }
    unit
  end
end
