class OutcomeValuesQuery
  attr_accessor :scope

  def initialize
    self.scope = Outcome
      .select("outcomes.id as outcome_id")
      .select("a1.year")
      .select("a1.company_id as company_id")
      .select("a1.value / coalesce(a2.value, 1) AS value")
      .joins("INNER JOIN mappings m ON m.outcome_id = outcomes.id")
      .joins("INNER JOIN questions q1 ON m.question_id = q1.id")
      .joins("INNER JOIN answers a1 ON a1.question_id = q1.id")
      .joins("INNER JOIN companies c1 ON a1.company_id = c1.id")
      .joins("LEFT JOIN questions q2 ON m.divisor_id = q2.id")
      .joins("LEFT JOIN answers a2 ON a2.question_id = q2.id")
      .joins("LEFT JOIN companies c2 ON a2.company_id = c2.id")
      .where("c1.id = c2.id AND a1.year = a2.year OR c2.id IS NULL")
  end

  def to_sql
    scope.to_sql
  end

  def results
    ActiveRecord::Base.connection.execute(scope.to_sql).to_a.map(&:symbolize_keys)
  end
end
