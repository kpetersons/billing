class AddColumnsToMatter < ActiveRecord::Migration
  def self.up
    add_column :matters,    :customer_id,    :integer
    add_column :matters,    :priority_date,  :date
    add_column :matters,    :ctm_number,     :string
    add_column :matters,    :wipo_number,    :string
    add_column :matters,    :ir_number,      :string
    
    add_column :documents, :parent_id,    :integer
  end

  def self.down
    remove_column :matters,   :customer_id    
    remove_column :matters,   :priority_date
    remove_column :matters,   :ctm_number
    remove_column :matters,   :wipo_number
    remove_column :matters,   :ir_number    
    
    remove_column :documents, :parent_id    
  end
end
