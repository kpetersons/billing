class AddColumnToAddressType < ActiveRecord::Migration
  def self.up
		add_column :address_types, :customer_id, :integer
  end

  def self.down
		remove_column :address_types, :customer_id
  end
end
