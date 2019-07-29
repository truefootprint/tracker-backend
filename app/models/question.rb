class Question < ApplicationRecord
  belongs_to :unit

  validates :text,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :unit, presence: true
end
