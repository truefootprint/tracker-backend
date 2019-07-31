class CompanyRankingsController < ApplicationController
  ID_FORMAT = /(\d{4})-outcome-(\d+)/

  before_action do # TODO: add the rack-cors gem?
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def show
    outcome = Outcome.find(outcome_id)
    ranking = CompanyRanking.new(outcome, year)
    presenter = CompanyRankingPresenter.new(ranking)

    render json: presenter
  end

  private

  def year
    params.fetch(:id)[ID_FORMAT, 1]
  end

  def outcome_id
    params.fetch(:id)[ID_FORMAT, 2]
  end
end
