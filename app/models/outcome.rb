class Outcome < ApplicationRecord
  belongs_to :unit

  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :higher_is_better, inclusion: [true, false]
end
