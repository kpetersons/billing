class AddColumnAttorneyTaskTypes < ActiveRecord::Migration
  def self.up
    add_column :attorney_fee_types, :apply_vat, :boolean
    add_column :attorney_fee_types, :apply_discount, :boolean
  end

  def self.down
  end
end
