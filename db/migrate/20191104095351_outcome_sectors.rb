class OutcomeSectors < ActiveRecord::Migration[5.2]
  def change
    create_table :outcome_sectors do |t|
      t.belongs_to :outcome
      t.belongs_to :sector
      t.timestamps
    end
  end
end
