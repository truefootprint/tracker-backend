class CompanyRankingsController < ApplicationController
  ID_FORMAT = /(outcome|group)-(\d+)-(\d+)/i

  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def show
    ranking = CompanyRanking.find_by!(
      rankable_type: rankable_type,
      rankable_id: rankable_id,
      sector: sector,
      threshold: threshold,
      year: year,
      company_id: company_id,
    )

    presenter = CompanyRankingsPresenter.new([ranking])

    render json: presenter.as_json.first
  end

  def outcome
    outcome = Outcome.find(id)

    rankings = CompanyRanking.where(
      rankable: outcome,
      sector: sector,
      threshold: threshold,
      year: year,
    ).order(:rank)

    rankings_with_ratio = OutcomeRatiosQuery.new(rankings).scope

    presenter = CompanyRankingsPresenter.new(rankings_with_ratio)

    render json: presenter
  end

  def group
    group = Group.find(id)

    rankings = CompanyRanking.where(
      rankable: group,
      sector: sector,
      threshold: threshold,
      year: year,
    ).order(:rank)

    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def company
    company = Company.find(id)

    rankings = CompanyRanking.where(
      company: company,
      sector: sector,
      threshold: threshold,
      year: year,
    ).order(:rank)

    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def history
    rankings = CompanyRanking.where(
      rankable: rankable,
      company_id: company_id,
      sector: sector,
      threshold: threshold,
    ).order(:year)

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

  def threshold
    params.fetch(:threshold).sub("-", ".")
  end

  def year
    params.fetch(:year)
  end

  def id
    params.fetch(:id)
  end

  def rankable
    rankable_type.constantize.find(rankable_id)
  end

  def rankable_type
    id[ID_FORMAT, 1].capitalize
  end

  def rankable_id
    id[ID_FORMAT, 2]
  end

  def company_id
    id[ID_FORMAT, 3]
  end
end
