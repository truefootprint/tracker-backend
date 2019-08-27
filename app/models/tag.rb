class Tag < ApplicationRecord
  belongs_to :target, polymorphic: true

  validates :name,
    presence: true,
    uniqueness: {
      scope: :target,
      case_sensitive: false
    }
end
