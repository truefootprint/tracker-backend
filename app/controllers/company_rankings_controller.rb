class CompanyRankingsController < ApplicationController
  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def outcome
    rankings = company_rankings(Outcome.find(id))
    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def group
    rankings = company_rankings(Group.find(id))
    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  private

  def company_rankings(rankable)
    CompanyRanking.where(rankable: rankable, sector: sector, year: year)
  end

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
