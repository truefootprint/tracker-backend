class Company < ApplicationRecord
  belongs_to :sector

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
