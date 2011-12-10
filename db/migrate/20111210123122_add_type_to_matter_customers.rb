class AddTypeToMatterCustomers < ActiveRecord::Migration
  def change
    add_column :matter_customers, :type, :string
  end
end
