class CreateMatterTypeStatussFlows < ActiveRecord::Migration
  def self.up
    create_table :matter_type_statuss_flows do |t|
      t.integer :revert_to_step_id
      t.integer :current_step_id
      t.integer :pass_to_step_id

      t.timestamps
    end
  end

  def self.down
    drop_table :matter_type_statuss_flows
  end
end
