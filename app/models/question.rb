class Question < ApplicationRecord
  belongs_to :unit

  validates :gri_code,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :text,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :unit, presence: true
end
