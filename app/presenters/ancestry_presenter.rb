class AncestryPresenter
  ALL = %i[parents ancestors children descendents]

  attr_accessor :ancestry, :relations

  def initialize(ancestry, relations)
    self.ancestry = ancestry
    self.relations = Array(relations)
  end

  def as_json(_options = {})
    hash = {}

    hash[:parents] = ancestry.parents if relations.include?(:parents)
    hash[:ancestors] = ancestry.ancestors if relations.include?(:ancestors)
    hash[:children] = ancestry.children if relations.include?(:children)
    hash[:descendents] = ancestry.descendents if relations.include?(:descendents)

    hash
  end
end
