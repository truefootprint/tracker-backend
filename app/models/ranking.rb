class Ranking < ApplicationRecord
  belongs_to :target, polymorphic: true
end
