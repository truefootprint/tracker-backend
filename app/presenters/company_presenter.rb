class CompanyPresenter
  attr_accessor :company

  def initialize(company)
    self.company = company
  end

  def as_json(_options = {})
    {
      id: company.id,
      name: company.name,
      logo: company.logo,
      sector_id: company.sector_id,
      sector_name: company.sector.name,
    }
  end
end
