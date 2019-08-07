class CompanyRankingsPresenter
  attr_accessor :scope

  def initialize(scope)
    self.scope = scope.order(:rank).includes(:company, :rankable)
  end

  def as_json(_options = {})
    scope.map do |r|
      {
        company_id: r.company.id,
        company_name: r.company.name,
        company_logo: r.company.logo,

        rankable_type: r.rankable_type,
        rankable_id: r.rankable_id,
        rankable_name: r.rankable.name,

        value: r.value,
        rank: r.rank,
        out_of: r.out_of,
        band: Banding.new.band(r.rank, r.out_of),
      }
    end
  end
end
