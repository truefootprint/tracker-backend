class CompanyRankingsController < ApplicationController
  ID_FORMAT = /(\d+)-(\d+)/

  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def show
    ranking = CompanyRanking.find_by!(
      rankable_type: "Outcome",
      rankable_id: rankable_id,
      sector: sector,
      year: year,
      company_id: company_id,
    )

    presenter = CompanyRankingsPresenter.new([ranking])

    render json: presenter.as_json.first
  end

  def outcome
    outcome = Outcome.find(id)

    rankings = CompanyRanking.where(rankable: outcome, sector: sector, year: year).order(:rank)
    rankings_with_ratio = OutcomeRatiosQuery.new(rankings).scope

    presenter = CompanyRankingsPresenter.new(rankings_with_ratio)

    render json: presenter
  end

  def group
    group = Group.find(id)
    rankings = CompanyRanking.where(rankable: group, sector: sector, year: year).order(:rank)
    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def company
    company = Company.find(id)
    rankings = CompanyRanking.where(company: company, sector: sector, year: year).order(:rank)
    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def trend
    outcome = Outcome.find(rankable_id)
    company = Company.find(company_id)

    rankings = CompanyRanking.where(rankable: outcome, company: company, sector: sector).order(:year)
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

  def rankable_id
    id[ID_FORMAT, 1]
  end

  def company_id
    id[ID_FORMAT, 2]
  end
end
