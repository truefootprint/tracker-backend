class RemoveGriCodeFromQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :gri_code, :string
  end
end
