class Company < ApplicationRecord
  belongs_to :sector

  has_many :outcome_values

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
