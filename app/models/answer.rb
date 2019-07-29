class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :company
  belongs_to :verifier, class_name: :Company, optional: true
  belongs_to :unit

  validates :question, presence: true
  validates :company, presence: true
  validates :year, presence: true, inclusion: 1950..2050

  validates :value,
    presence: true,
    uniqueness: { scope: [:question, :company, :year] }

  validates :unit, presence: true
  validate :unit_matches_question

  private

  def unit_matches_question
    return if unit == question&.unit
    errors.add(:unit, "does not match the question's unit")
  end
end
