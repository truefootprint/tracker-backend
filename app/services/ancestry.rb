class Ancestry
  attr_accessor :member, :child_to_parents, :parent_to_children

  def initialize(member)
    self.member = member
  end

  def parents(child = member_key)
    child_to_parents[child].map do |parent|
      { type: parent[0], id: parent[1] }
    end
  end

  def ancestors(child = member_key)
    child_to_parents[child].map do |parent|
      { type: parent[0], id: parent[1], ancestors: ancestors(parent) }
    end
  end

  def children(parent = member_key)
    parent_to_children[parent].map do |child|
      { type: child[0], id: child[1] }
    end
  end

  def descendents(parent = member_key)
    parent_to_children[parent].map do |child|
      { type: child[0], id: child[1], descendents: descendents(child) }
    end
  end

  private

  def member_key
    [member.class.name, member.id]
  end

  def child_to_parents
    @child_to_parents ||= (
      results = AncestorsQuery.new(member).execute
      array_default = Hash.new { |k, v| k[v] = [] }

      results.each.with_object(array_default) do |result, parents|
        child = result.values_at(:child_type, :child_id)
        parent = result.values_at(:parent_type, :parent_id)

        parents[child] << parent
      end
    )
  end

  def parent_to_children
    @parent_to_children ||= (
      results = DescendentsQuery.new(member).execute
      array_default = Hash.new { |k, v| k[v] = [] }

      results.each.with_object(array_default) do |result, children|
        parent = result.values_at(:parent_type, :parent_id)
        child = result.values_at(:child_type, :child_id)

        children[parent] << child
      end
    )
  end
end
