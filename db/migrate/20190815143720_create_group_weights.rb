class CreateGroupWeights < ActiveRecord::Migration[5.2]
  def change
    create_table :group_weights do |t|
      t.string :name
      t.belongs_to :group
      t.float :weight
    end

    add_index :group_weights, :name
  end
end
