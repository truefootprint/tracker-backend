class DescendentsQuery
  attr_accessor :group

  def initialize(group)
    self.group = group
  end

  def execute
    return [] unless group.is_a?(Group)

    ActiveRecord::Base.connection.execute(to_sql).to_a.map(&:symbolize_keys)
  end

  def to_sql
    <<-SQL
      with recursive x(parent_type, parent_id, child_type, child_id) as (
        select cast('Group' as text), group_id, member_type, member_id
        from group_members where group_id = #{group.id}

        union all

        select x.child_type, x.child_id, gm.member_type, gm.member_id
        from group_members gm
        join x on x.child_type = 'Group' and x.child_id = gm.group_id
      )
      select * from x
    SQL
  end
end
