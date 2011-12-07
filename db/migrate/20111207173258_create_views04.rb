class CreateViews04 < ActiveRecord::Migration
  def up
    execute <<-SQL
      drop view if exists v_matter_tasks;
    SQL
    execute <<-SQL
      create view v_matter_tasks as (
        select
          mt.id,
          mt.matter_id,
          m.registration_number,
          m.matter_type,
          mtt.name as task_type,
          mts.name as status,
          substring(mt.description from 1 for 150) as description,
          mt.proposed_deadline as deadline,
          mt.created_at,
          mt.updated_at
        from
          matter_tasks mt,
          v_matters m,
          matter_task_statuses mts,
          matter_task_types mtt
        where
          mt.matter_id = m.id
          and mts.id = mt.matter_task_status_id
          and mtt.id = mt.matter_task_type_id
      );
    SQL
  end

  def down
  end
end
