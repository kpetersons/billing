class CreateMatterStatuses < ActiveRecord::Migration
  def self.up
    create_table :matter_statuses do |t|
      t.string :name
      t.string :revert_to_name
      t.string :pass_to_name
           
      t.timestamps
    end
  end

  def self.down
    drop_table :matter_statuses
  end
end
