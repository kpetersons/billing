class AddColumnToCustomer2 < ActiveRecord::Migration
  def self.up
		add_column :customers, :vat_registration_number, :string
		remove_column :customers, :customer_since
  end

  def self.down
		remove_column :customers, :vat_registration_number
		add_column :customers, :customer_since, :date
  end
end
