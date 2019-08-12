class AddAuditorToOutcomes < ActiveRecord::Migration[5.2]
  def change
    add_reference :outcomes, :auditor, index: true
  end
end
