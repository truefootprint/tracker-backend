class Ranking < ApplicationRecord
  belongs_to :target, polymorphic: true

  validates :target, presence: true
end
