class CompanyRankingsPresenter
  attr_accessor :scope

  def initialize(scope)
    if scope.respond_to?(:includes)
      self.scope = scope.includes(:company, :rankable, :auditor)
    else
      self.scope = scope
    end
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

        auditor_id: r.auditor_id,
        auditor_name: r.auditor&.name,

        year: r.year,
        value: r.value,
        unit_name: unit_name(r),

        rank: r.rank,
        out_of: r.out_of,
        band: Banding.new.band(r.rank, r.out_of),

        data_points: r.count,
        ratio_of: ratio_of(r),
      }
    end
  end

  private

  def unit_name(ranking)
    ranking.rankable.unit&.name if ranking.rankable.is_a?(Outcome)
  end

  def ratio_of(ranking)
    return [] unless ranking.respond_to?(:numerator_id)
    return [] unless ranking.numerator_id

    [
      { outcome_id: ranking.numerator_id, outcome_name: ranking.numerator_name },
      { outcome_id: ranking.denominator_id, outcome_name: ranking.denominator_name },
    ]
  end
end
