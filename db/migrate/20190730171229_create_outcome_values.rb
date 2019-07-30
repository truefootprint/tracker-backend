class CreateOutcomeValues < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      create materialized view if not exists outcome_values as (
        select
          o.id as outcome_id,
          c1.id as company_id,
          a1.year,
          a1.value / coalesce(a2.value, 1) as value

        from outcomes o
        join mappings m on m.outcome_id = o.id

        join questions q1 on m.question_id = q1.id
        join answers a1 on a1.question_id = q1.id
        join companies c1 on a1.company_id = c1.id

        left join questions q2 on m.divisor_id = q2.id
        left join answers a2 on a2.question_id = q2.id
        left join companies c2 on a2.company_id = c2.id

        where c1.id = c2.id and a1.year = a2.year
        or c2.id is null
      ) with data
    SQL
  end

  def down
    execute("drop materialized view if exists outcome_values")
  end
end
