class AddColumnToAddressType1 < ActiveRecord::Migration
  def self.up
    remove_column :address_types, :customer_id
		add_column :address_types, :party_id, :integer
  end

  def self.down
		remove_column :address_types, :party_id
  end
end
