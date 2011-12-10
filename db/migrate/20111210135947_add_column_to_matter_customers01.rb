class AddColumnToMatterCustomers01 < ActiveRecord::Migration
  def change
    add_column :matter_customers, :author_id, :integer
  end
end
