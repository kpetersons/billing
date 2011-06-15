class AddColumnsToMatter3 < ActiveRecord::Migration
  def self.up
    add_column :matters,    :agent_id, :integer    
    rename_column :matters, :customer_id, :applicant_id    
  end

  def self.down
    remove_column :matters,    :agent_id    
    rename_column :matters, :applicant_id, :customer_id    
  end
end
