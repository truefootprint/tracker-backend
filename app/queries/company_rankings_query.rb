class CompanyRankingsQuery
  def execute
    ActiveRecord::Base.connection.execute(to_sql).to_a.map(&:symbolize_keys)
  end

  def to_sql
    <<~SQL
      with recursive r(rankable_type, rankable_id, company_id, sector_id, year, value, count, rank) as (
        select 'Outcome', o.id, c.id, c.sector_id, y, value,
          case when ov is null then cast(0 as bigint) else cast(1 as bigint) end,

          case when ov is null then null else rank() over(
            partition by outcome_id, sector_id, year
            order by case when o.higher_is_better then -value else value end
          ) end

        from outcomes o
        cross join companies c
        cross join (select distinct year as y from outcome_values) _
        left join outcome_values ov
          on ov.company_id = c.id
          and ov.outcome_id = o.id
          and year = y

        union all

        select 'Group', group_id, company_id, sector_id, year, avg_rank, count,
          case when cast(count as float) / size < 0.5 then null else rank() over(
            partition by group_id, sector_id, year
            order by case when cast(count as float) / size < 0.5 then null else avg_rank end
          ) end

        from (
          select distinct group_id, company_id, sector_id, year,
            avg(r.rank)   over(partition by group_id, company_id, sector_id, year) as avg_rank,
            count(r.rank) over(partition by group_id, company_id, sector_id, year) as count

          from groups g
          join group_members gm on gm.group_id = g.id
          join r on r.rankable_type = gm.member_type and r.rankable_id = gm.member_id
        ) _
        join group_sizes gs on gs.id = group_id
      ),
      group_sizes as (
        select group_id as id, count(1) as size from group_members group by group_id
      )
      select * from r
    SQL
  end
end
