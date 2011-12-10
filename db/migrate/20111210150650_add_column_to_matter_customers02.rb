class AddColumnToMatterCustomers02 < ActiveRecord::Migration
  def change
    remove_column :matter_customers, :type
    add_column :matter_customers, :customer_type, :integer
  end
end
