class CompanyRankingsController < ApplicationController
  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def outcome
    outcome = Outcome.find(id)
    rankings = CompanyRanking.where(rankable: outcome, sector: sector, year: year)
    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def group
    group = Group.find(id)
    rankings = CompanyRanking.where(rankable: group, sector: sector, year: year)
    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def company
    company = Company.find(id)
    rankings = CompanyRanking.where(company: company, sector: sector, year: year)
    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  private

  def sector
    Sector.find_by!(name: sector_name)
  end

  def sector_name
    params.fetch(:sector)
  end

  def year
    params.fetch(:year)
  end

  def id
    params.fetch(:id)
  end
end
