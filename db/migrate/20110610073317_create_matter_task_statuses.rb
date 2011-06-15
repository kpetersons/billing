class CreateMatterTaskStatuses < ActiveRecord::Migration
  def self.up
    create_table :matter_task_statuses do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :matter_task_statuses
  end
end
