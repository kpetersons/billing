class AddColumnToOfficialFeeTypes < ActiveRecord::Migration
  def self.up
    add_column :official_fee_types, :apply_vat, :boolean
    add_column :official_fee_types, :apply_discount, :boolean
  end

  def self.down
  end
end
