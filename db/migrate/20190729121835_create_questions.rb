class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :gri_code
      t.text :text
      t.belongs_to :unit

      t.timestamps
    end

    add_index :questions, :gri_code, unique: true
    add_index :questions, :text, unique: true
  end
end
