class CreateOutcomes < ActiveRecord::Migration[5.2]
  def change
    create_table :outcomes do |t|
      t.text :name
      t.boolean :higher_is_better, null: false
      t.belongs_to :unit

      t.timestamps
    end

    add_index :outcomes, :name, unique: true
  end
end
