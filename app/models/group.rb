class Group < ApplicationRecord
  has_many :group_members

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
