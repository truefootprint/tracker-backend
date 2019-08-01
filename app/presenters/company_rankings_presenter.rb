class CompanyRankingsPresenter
  attr_accessor :company_rankings, :rankable

  def initialize(company_rankings)
    self.company_rankings = company_rankings
  end

  def as_json(_options = {})
    { name: rankable.name, ranked_companies: ranked_companies }
  end

  private

  def rankable
    company_rankings.first.rankable
  end

  def ranked_companies
    companies.zip(values, ranks, bands).map { |arr| arr.inject(:merge) }
  end

  def companies
    company_rankings.map { |c| CompanyPresenter.new(c.company).as_json }
  end

  def values
    company_rankings.map { |c| { value: c.value } }
  end

  def ranks
    company_rankings.map { |c| { rank: c.rank } }
  end

  def bands
    company_rankings.map do |company|
      { band: Banding.new.band(company.rank, company_rankings.count) }
    end
  end
end
