class AncestryController < ApplicationController
  TYPES = %w[outcome group].freeze

  def show
    render json: AncestryPresenter.new(ancestry, AncestryPresenter::ALL)
  end

  def parents
    render json: AncestryPresenter.new(ancestry, :parents)
  end

  def ancestors
    render json: AncestryPresenter.new(ancestry, :ancestors)
  end

  def children
    render json: AncestryPresenter.new(ancestry, :children)
  end

  def descendents
    render json: AncestryPresenter.new(ancestry, :descendents)
  end

  private

  def ancestry
    Ancestry.new(member, sector)
  end

  def member
    raise unless TYPES.include?(type)

    type.capitalize.constantize.find(id)
  end

  def sector
    Sector.find_by!(name: params.fetch(:sector))
  end

  def type
    params.fetch(:type)
  end

  def id
    params.fetch(:id)
  end
end
