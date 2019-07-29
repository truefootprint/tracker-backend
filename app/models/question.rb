class Question < ApplicationRecord
  validates :gri_code,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :text,
    presence: true,
    uniqueness: { case_sensitive: false }
end
