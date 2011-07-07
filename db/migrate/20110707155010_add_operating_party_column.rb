class AddOperatingPartyColumn < ActiveRecord::Migration
  def self.up
		add_column :attorney_fee_types, :operating_party_id, :integer
		add_column :official_fee_types, :operating_party_id, :integer
  end

  def self.down
		remove_column :official_fee_types, :operating_party_id
		remove_column :attorney_fee_types, :operating_party_id
  end
end
