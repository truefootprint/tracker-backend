class OutcomeRatiosQuery
  attr_accessor :company_rankings

  def initialize(company_rankings)
    self.company_rankings = company_rankings
  end

  def execute
    scope
  end

  def to_sql
    scope.to_sql
  end

  def scope
    scope = join_mappings(company_rankings)
    scope = left_join_on_question(scope)
    scope = left_join_on_divisor(scope)

    select_numerator_and_denominator(scope)
  end

  private

  def join_mappings(scope)
    scope.joins(<<~SQL)
      inner join mappings m
      on company_rankings.rankable_id = m.outcome_id
    SQL
  end

  def left_join_on_question(scope)
    scope.joins(<<~SQL)
      left join mappings m2
      on m.question_id = m2.question_id
      and m2.divisor_id is null
      and m.divisor_id is not null
    SQL
  end

  def left_join_on_divisor(scope)
    scope.joins(<<~SQL)
      left join mappings m3
      on m.divisor_id = m3.question_id
      and m3.divisor_id is null
    SQL
  end

  def select_numerator_and_denominator(scope)
    scope.select(<<~SQL)
      *,

      m2.outcome_id as numerator_id,
      m3.outcome_id as denominator_id,

      (select name from outcomes where id = m2.outcome_id) as numerator_name,
      (select name from outcomes where id = m3.outcome_id) as denominator_name
    SQL
  end
end
