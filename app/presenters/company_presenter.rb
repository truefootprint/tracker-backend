class CompanyPresenter
  attr_accessor :company

  def initialize(company)
    self.company = company
  end

  def as_json(_options = {})
    { name: company.name }
  end
end
