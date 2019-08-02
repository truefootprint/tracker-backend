class CreateOutcomeValues < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create materialized view outcome_values as (
        #{OutcomeValuesQuery.new.to_sql}
      ) with data
    SQL

    add_index :outcome_values, :outcome_id
    add_index :outcome_values, :company_id
    add_index :outcome_values, :year
  end

  def down
    remove_index :outcome_values, :outcome_id
    remove_index :outcome_values, :company_id
    remove_index :outcome_values, :year

    execute("drop materialized view outcome_values")
  end
end
