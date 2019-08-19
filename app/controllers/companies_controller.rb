class CompaniesController < ApplicationController
  def show
    company = Company.find(params.fetch(:id))
    presenter = CompanyPresenter.new(company)

    render json: presenter
  end
end
