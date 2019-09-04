class CompareController < ApplicationController
  def compare
    rankings = CompanyRanking.where(
      rankable: rankable,
      sector: sector,
      distribution: distribution,
      threshold: threshold,
    ).order(:year)

    presenter = ComparisonPresenter.new(rankings)

    render json: presenter
  end
end
