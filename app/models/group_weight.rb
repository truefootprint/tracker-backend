class GroupWeight < ApplicationRecord
  belongs_to :group

  validates :name, presence: true
  validates :group, presence: true
  validates :weight, presence: true
end
