class RemoveColumnToMatter1 < ActiveRecord::Migration
  def self.up
    remove_column :trademarks, :description    
    remove_column :designs, :description    
    remove_column :legals, :description
    remove_column :customs, :description
  end

  def self.down
  end
end
