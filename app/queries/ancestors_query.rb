class AncestorsQuery
  attr_accessor :member

  def initialize(member)
    self.member = member
  end

  def execute
    ActiveRecord::Base.connection.execute(to_sql).to_a.map(&:symbolize_keys)
  end

  def to_sql
    <<-SQL
      with recursive x(child_type, child_id, parent_type, parent_id) as (
        select member_type, member_id, 'Group', group_id
        from group_members
        where member_type = '#{member.class}' and member_id = #{member.id}

        union all

        select gm.member_type, gm.member_id, 'Group', gm.group_id
        from group_members gm
        join x on gm.member_type = 'Group' and x.parent_id = gm.member_id
      )
      select * from x
    SQL
  end
end
