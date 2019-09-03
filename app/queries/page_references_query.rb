class PageReferencesQuery
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
    company_rankings.joins(<<~SQL)
      left join (
        select m.outcome_id, a.company_id as c_id, a.year, pr.url, pr.page
        from page_references pr
        join answers a on pr.answer_id = a.id
        join questions q on a.question_id = q.id
        join mappings m on m.question_id = q.id
      ) refs
      on refs.c_id = company_rankings.company_id
      and refs.year = company_rankings.year
      and refs.outcome_id = company_rankings.rankable_id
      and company_rankings.rankable_type = 'Outcome'
    SQL
  end
end
