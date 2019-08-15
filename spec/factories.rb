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
    higher_is_better { false }
    unit
  end

  factory :mapping do
    outcome
    question
  end

  factory :group do
    sequence(:name) { |n| "Group #{n}" }
  end

  factory :group_member do
    group
    association :member, factory: :outcome
  end

  factory :outcome_value do
    outcome
    company
  end

  factory :company_ranking do
    association :rankable, factory: :outcome
    company
    sector
  end

  factory :group_weight do
    sequence(:name) { |n| "Group Weight #{n}" }
    group
    weight { 0.25 }
  end
end
