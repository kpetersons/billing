class RenameAttorneysFeeType < ActiveRecord::Migration
  def self.up
		rename_table :attorneys_fee_types, :attorney_fee_types
  end

  def self.down
		rename_table :attorney_fee_types, :attorneys_fee_types
  end
end
