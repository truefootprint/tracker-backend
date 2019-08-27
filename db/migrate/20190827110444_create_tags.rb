class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.belongs_to :target, polymorphic: true
      t.string :name
    end

    add_index :tags, [:target_id, :name], unique: true
    add_index :tags, :name
  end
end
