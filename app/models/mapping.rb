class Mapping < ApplicationRecord
  belongs_to :outcome
  belongs_to :question
  belongs_to :divisor, class_name: :Question, optional: true
end
