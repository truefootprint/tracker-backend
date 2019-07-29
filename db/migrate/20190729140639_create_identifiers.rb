class CreateIdentifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :identifiers do |t|
      t.belongs_to :target, polymorphic: true

      t.string :name
      t.string :value

      t.timestamps
    end

    add_index :identifiers, [:target_type, :target_id, :name], unique: true
  end
end
