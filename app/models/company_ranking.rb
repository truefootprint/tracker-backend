class CompanyRanking
  include Enumerable

  attr_accessor :outcome, :year, :ranking

  def initialize(outcome, year)
    self.outcome = outcome
    self.year = year
    self.ranking = Ranking.new(companies, order)
  end

  def each(&block)
    ranking.each(&block)
  end

  private

  def companies
    Company.joins(:outcome_values)
      .where(outcome_values: { outcome: outcome, year: year })
  end

  def order
    outcome.higher_is_better ? "value desc" : "value asc"
  end
end
