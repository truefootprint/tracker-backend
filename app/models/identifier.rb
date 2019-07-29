class Identifier < ApplicationRecord
  belongs_to :target, polymorphic: true

  validates :name, presence: true

  validates :value,
    presence: true,
    uniqueness: { scope: [:target, :name] }
end
