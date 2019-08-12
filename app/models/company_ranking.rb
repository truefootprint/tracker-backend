class CompanyRanking < ApplicationRecord
  belongs_to :rankable, polymorphic: true
  belongs_to :company
  belongs_to :sector
  belongs_to :auditor, class_name: :Company, optional: true

  def self.refresh
    ActiveRecord::Base.connection.execute("refresh materialized view #{table_name}")
  end
end
