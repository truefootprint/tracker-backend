class Ancestry
  attr_accessor :member, :sector, :seen

  def initialize(member, sector)
    self.member = member
    self.sector = sector
    self.seen = Set[member_key]
  end

  def parents(child = member_key)
    child_to_parents[child].each { |p| seen << p }
  end

  def ancestors(child = member_key)
    parents(child).map { |p| p.merge(ancestors: ancestors(p)) }
  end

  def children(parent = member_key)
    parent_to_children[parent].each { |c| seen << c }
  end

  def descendents(parent = member_key)
    children(parent).map { |p| p.merge(descendents: descendents(p)) }
  end

  private

  def member_key
    { type: member.class.name, id: member.id }
  end

  def child_to_parents
    @child_to_parents ||= (
      results = AncestorsQuery.new(member).execute
      array_default = Hash.new { |k, v| k[v] = [] }

      results.each.with_object(array_default) do |result, parents|
        child = { type: result[:child_type], id: result[:child_id] }
        parent = { type: result[:parent_type], id: result[:parent_id] }

        parents[child] << parent
      end
    )
  end

  def parent_to_children
    @parent_to_children ||= (
      results = DescendentsQuery.new(member, sector).execute
      array_default = Hash.new { |k, v| k[v] = [] }

      results.each.with_object(array_default) do |result, children|
        parent = { type: result[:parent_type], id: result[:parent_id] }
        child = { type: result[:child_type], id: result[:child_id] }

        children[parent] << child
      end
    )
  end
end
