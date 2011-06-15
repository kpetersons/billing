class AddColumnsToMatter2 < ActiveRecord::Migration
  def self.up
    add_column :matters,    :appl_date,    :date    
    add_column :matters,    :appl_number,  :string
  end

  def self.down
    remove_column :matters,    :appl_date    
    remove_column :matters,    :appl_number    
  end
end
