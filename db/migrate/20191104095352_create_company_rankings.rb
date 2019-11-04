class CreateCompanyRankings < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create materialized view company_rankings as (
        #{CompanyRankingsQuery.new.to_sql}
      ) with data
    SQL

    add_index :company_rankings, [:rankable_type, :rankable_id]
    add_index :company_rankings, :company_id
    add_index :company_rankings, :year
    add_index :company_rankings, :rank
    add_index :company_rankings, :threshold
  end

  def down
    remove_index :company_rankings, [:rankable_type, :rankable_id]
    remove_index :company_rankings, :company_id
    remove_index :company_rankings, :year
    remove_index :company_rankings, :rank
    remove_index :company_rankings, :threshold

    execute("drop materialized view company_rankings")
  end
end
