class CreateCompanyRankings < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create materialized view if not exists company_rankings as (
        with recursive r(rankable_type, rankable_id, company_id, year, value, count, rank) as (
          select
            'Outcome',
            outcome_id,
            company_id,
            year,
            value,
            cast(1 as bigint),
            rank() over(
              partition by outcome_id, year
              order by case when o.higher_is_better then -value else value end
            )

          from outcome_values ov
          join outcomes o on ov.outcome_id = o.id

          union all

          select
            'Group',
            group_id,
            company_id,
            year,
            avg_rank,
            count,
            case when cast(count as float) / size < 0.5 then null else rank() over(
              partition by group_id, year
              order by case when cast(count as float) / size < 0.5 then null else avg_rank end
            ) end

          from (
            select distinct
              group_id,
              company_id,
              year,
              avg(r.rank) over(partition by group_id, company_id, year) as avg_rank,
              count(1)    over(partition by group_id, company_id, year) as count

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
      ) with data
    SQL

    add_index :company_rankings, [:rankable_type, :rankable_id]
    add_index :company_rankings, :company_id
    add_index :company_rankings, :year
    add_index :company_rankings, :rank
  end

  def down
    remove_index :company_rankings, [:rankable_type, :rankable_id]
    remove_index :company_rankings, :company_id
    remove_index :company_rankings, :year
    remove_index :company_rankings, :rank

    execute("drop materialized view if exists company_rankings")
  end
end
