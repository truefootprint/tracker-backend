class CompanyRanking < ApplicationRecord
  belongs_to :rankable, polymorphic: true
  belongs_to :company

  def self.refresh
    ActiveRecord::Base.connection.execute("refresh materialized view #{table_name}")
  end
end
