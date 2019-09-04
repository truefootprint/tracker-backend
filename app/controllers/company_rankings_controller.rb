class CompanyRankingsController < ApplicationController
  ID_FORMAT = /(outcome|group)-(\d+)-(\d+)/i

  def show
    ranking = CompanyRanking.find_by!(
      rankable_type: rankable_type,
      rankable_id: rankable_id,
      sector: sector,
      distribution: distribution,
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
      distribution: distribution,
      threshold: threshold,
      year: year,
      company_id: tagged_company_ids,
    ).order(:rank)

    rankings_with_ratio = OutcomeRatiosQuery.new(rankings).scope
    rankings_with_refs = PageReferencesQuery.new(rankings_with_ratio).scope

    presenter = CompanyRankingsPresenter.new(rankings_with_refs)

    render json: presenter
  end

  def group
    group = Group.find(id)

    rankings = CompanyRanking.where(
      rankable: group,
      sector: sector,
      distribution: distribution,
      threshold: threshold,
      year: year,
      company_id: tagged_company_ids,
    ).order(:rank)

    presenter = CompanyRankingsPresenter.new(rankings)

    render json: presenter
  end

  def company
    company = Company.find(id)

    rankings = CompanyRanking.where(
      company: company,
      sector: sector,
      distribution: distribution,
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
      distribution: distribution,
      threshold: threshold,
    ).order(:year)

    rankings_with_refs = PageReferencesQuery.new(rankings).scope
    presenter = CompanyRankingsPresenter.new(rankings_with_refs)

    render json: presenter
  end

  def compare
    rankings = CompanyRanking.where(
      rankable: rankable,
      sector: sector,
      distribution: distribution,
      threshold: threshold,
    ).where.not(
      company_id: company_id,
    )

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

  def distribution
    params.fetch(:distribution)
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

  def tagged_company_ids
    if tag_names.any?
      tags.where(target_type: "Company").pluck(:target_id)
    else
      Company.all.pluck(:id)
    end
  end

  def tags
    Tag.where(name: tag_names)
  end

  def tag_names
    params.fetch(:tags, "").split(",")
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
