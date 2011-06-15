class AddColumnToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers,    :customer_type,    :string
  end

  def self.down
    remove_column :customers,    :customer_type    
  end
end
