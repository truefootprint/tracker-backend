class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.text :name, index: { unique: true }
      t.timestamps
    end

    create_table :group_members do |t|
      t.belongs_to :group
      t.belongs_to :member, polymorphic: true
      t.timestamps
    end

    add_index :group_members, [:group_id, :member_type, :member_id], unique: true
  end
end
