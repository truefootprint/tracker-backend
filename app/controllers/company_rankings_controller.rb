class CompanyRankingsController < ApplicationController
  ID_FORMAT = /(\d{4})-(outcome|group)-(\d+)/

  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def show
    rankable = rankable_class.find(rankable_id)
    ranking = CompanyRanking.new(rankable, year)
    presenter = CompanyRankingPresenter.new(ranking)

    render json: presenter
  end

  private

  def year
    params.fetch(:id)[ID_FORMAT, 1]
  end

  def rankable_class
    params.fetch(:id)[ID_FORMAT, 2].capitalize.constantize
  end

  def rankable_id
    params.fetch(:id)[ID_FORMAT, 3]
  end
end