FactoryBot.define do
  factory :sector do
    sequence(:name) { |n| "Sector #{n}" }
  end
end
