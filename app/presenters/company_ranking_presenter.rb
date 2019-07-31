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
    companies.zip(values, ranks, bands).map { |arr| arr.inject(:merge) }
  end

  def companies
    company_ranking.map { |c| CompanyPresenter.new(c).as_json }
  end

  def values
    company_ranking.map { |c| { value: c.value } }
  end

  def ranks
    company_ranking.map { |c| { rank: c.rank } }
  end

  def bands
    company_ranking.map do |company|
      { band: Banding.new.band(company.rank, company_ranking.count) }
    end
  end
end
