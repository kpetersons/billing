class CreateInvoiceStatusFlows < ActiveRecord::Migration
  def self.up
    create_table :invoice_status_flows do |t|
      t.integer  :revert_to_step_id
      t.integer  :current_step_id
      t.integer  :pass_to_step_id
      t.integer  :pass_to_function_id
      t.integer  :revert_to_function_id      
      t.boolean  :start_state,           :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_status_flows
  end
end
