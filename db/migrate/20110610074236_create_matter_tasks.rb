class CreateMatterTasks < ActiveRecord::Migration
  def self.up
    create_table :matter_tasks do |t|
      t.references :matter
      t.references :matter_task_status
      t.string :description
      t.date :proposed_deadline

      t.timestamps
    end
  end

  def self.down
    drop_table :matter_tasks
  end
end
