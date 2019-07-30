class OutcomeValue < ApplicationRecord
  def self.refresh
    ActiveRecord::Base.connection.execute("refresh materialized view #{table_name}")
  end

  def readonly?
    true
  end
end
