class CompanyRankingsController < ApplicationController
  ID_FORMAT = /([^-]+)-(\d{4})-(outcome|group)-(\d+)/

  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def show
    rankable = rankable_class.find(rankable_id)

    company_rankings = CompanyRanking.where(
      rankable: rankable,
      sector: sector,
      year: year,
    )

    presenter = CompanyRankingsPresenter.new(company_rankings)

    render json: presenter
  end

  private

  def sector
    Sector.find_by!(name: sector_name)
  end

  def sector_name
    params.fetch(:id)[ID_FORMAT, 1]
  end

  def year
    params.fetch(:id)[ID_FORMAT, 2]
  end

  def rankable_class
    params.fetch(:id)[ID_FORMAT, 3].capitalize.constantize
  end

  def rankable_id
    params.fetch(:id)[ID_FORMAT, 4]
  end
end
