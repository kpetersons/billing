class ChangeMatterCustomersColumn < ActiveRecord::Migration
  def up
    remove_column :matter_customers, :customer_type
    add_column :matter_customers, :customer_type, :string
  end

  def down
  end
end
