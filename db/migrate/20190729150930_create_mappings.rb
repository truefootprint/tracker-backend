class CreateMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :mappings do |t|
      t.belongs_to :outcome, index: { unique: true }
      t.belongs_to :question
      t.belongs_to :divisor, optional: true

      t.timestamps
    end
  end
end
