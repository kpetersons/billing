class AddColumnsToMatter1 < ActiveRecord::Migration
  def self.up
    add_column :matters,    :mark_name,    :string    
  end

  def self.down
    remove_column :matters,    :mark_name    
  end
end
