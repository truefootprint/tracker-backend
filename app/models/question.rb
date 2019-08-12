class Question < ApplicationRecord
  belongs_to :unit, optional: true

  validates :text,
    presence: true,
    uniqueness: { case_sensitive: false }
end
