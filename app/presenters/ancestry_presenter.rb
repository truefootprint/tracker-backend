class AncestryPresenter
  ALL = %i[parents ancestors children descendents]

  attr_accessor :ancestry, :relations, :fields

  def initialize(ancestry, relations, fields = %i[name])
    self.ancestry = ancestry
    self.relations = Array(relations)
    self.fields = fields
  end

  def as_json(_options = {})
    hash = {}

    hash[:parents] = ancestry.parents if relations.include?(:parents)
    hash[:ancestors] = ancestry.ancestors if relations.include?(:ancestors)
    hash[:children] = ancestry.children if relations.include?(:children)
    hash[:descendents] = ancestry.descendents if relations.include?(:descendents)

    hash.merge(attributes: attributes)
  end

  private

  def attributes
    members_by_type.each.with_object({}) do |(type, members), types|
      types[type] = type.constantize
        .where(id: member_ids(members))
        .pluck(:id, *fields)
        .each.with_object({}) { |(id, *v), ids| ids[id] = fields.zip(v).to_h }
    end
  end

  def members_by_type
    ancestry.seen.group_by { |m| m.fetch(:type) }
  end

  def member_ids(members)
    members.map { |m| m.fetch(:id) }
  end
end
