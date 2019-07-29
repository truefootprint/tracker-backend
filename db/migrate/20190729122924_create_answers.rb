class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.belongs_to :question
      t.belongs_to :company
      t.integer :year

      t.float :value
      t.belongs_to :unit
      t.belongs_to :verifier

      t.timestamps
    end

    add_index :answers, [:question_id, :company_id, :year], unique: true
  end
end
