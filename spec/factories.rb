FactoryBot.define do
  factory :sector do
    sequence(:name) { |n| "Sector #{n}" }
  end

  factory :company do
    sequence(:name) { |n| "Company #{n}" }
    sector
  end
end
