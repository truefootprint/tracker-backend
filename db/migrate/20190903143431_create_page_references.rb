class CreatePageReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :page_references do |t|
      t.belongs_to :answer
      t.text :url
      t.integer :page
      t.timestamps
    end
  end
end
