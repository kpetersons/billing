class AddColumnToCustom < ActiveRecord::Migration
  def self.up
    remove_column :customs, :client_all_ip    
		add_column :customs, :client_all_ip_id, :integer
  end

  def self.down
		remove_column :customs, :client_all_ip_id
		add_column :customs, :client_all_ip, :integer
  end
end
