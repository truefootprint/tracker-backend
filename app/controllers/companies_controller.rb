class CompaniesController < ApplicationController
  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def show
    company = Company.find(params.fetch(:id))
    presenter = CompanyPresenter.new(company)

    render json: presenter
  end
end
