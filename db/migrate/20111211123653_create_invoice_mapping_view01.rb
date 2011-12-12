class CreateInvoiceMappingView01 < ActiveRecord::Migration
  def up
    add_column :invoices, :matter_type_id, :integer
  end

  def down
  end
end
