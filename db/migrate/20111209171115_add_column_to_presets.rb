class AddColumnToPresets < ActiveRecord::Migration
  def up
    add_column :invoice_line_presets, :currency_id,        :integer
    add_column :invoice_line_presets, :orig_id,        :integer
    add_column :invoice_line_presets, :date_effective,     :date
    add_column :invoice_line_presets, :date_effective_end, :date
  end

  def down
  end
end
