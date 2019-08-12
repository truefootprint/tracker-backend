class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :company
  belongs_to :auditor, class_name: :Company, optional: true
  belongs_to :unit, optional: true

  validates :year, presence: true, inclusion: 1950..2050

  validates :value,
    presence: true,
    uniqueness: { scope: [:question, :company, :year] }

  #validate :unit_matches_question

  private

  def unit_matches_question
    return if unit == question&.unit
    errors.add(:unit, "does not match the question's unit")
  end
end
