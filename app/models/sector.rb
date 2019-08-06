class Sector < ApplicationRecord
  has_many :companies

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
