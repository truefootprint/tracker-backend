class CompanyRankingPresenter
  attr_accessor :company_ranking

  def initialize(company_ranking)
    self.company_ranking = company_ranking
  end

  def as_json(_options = {})
    { outcome: outcome, ranked_companies: ranked_companies }
  end

  private

  def outcome
    OutcomePresenter.new(company_ranking.outcome)
  end

  def ranked_companies
    companies.zip(ranks_and_values).map { |c, r| c.merge(r) }
  end

  def companies
    company_ranking.map { |c| CompanyPresenter.new(c).as_json }
  end

  def ranks_and_values
    company_ranking.map { |c| { rank: c.rank, value: c.value } }
  end
end
