class OutcomeValue < ApplicationRecord
  belongs_to :outcome
  belongs_to :company

  def self.refresh
    ActiveRecord::Base.connection.execute("refresh materialized view #{table_name}")
  end

  def readonly?
    true
  end
end
