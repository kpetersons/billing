class ChangeFeePresetsColumn < ActiveRecord::Migration
  def self.up
    remove_column :invoice_line_presets, :official_fee    
		add_column    :invoice_line_presets, :official_fee, :decimal, :precision => 8, :scale => 2
    remove_column :invoice_line_presets, :attorney_fee    
    add_column    :invoice_line_presets, :attorney_fee, :decimal, :precision => 8, :scale => 2		
  end

  def self.down
    remove_column :invoice_line_presets, :official_fee
    add_column    :invoice_line_presets, :official_fee, :decimal, :precision => 8, :scale => 2
    remove_column :invoice_line_presets, :attorney_fee
    add_column    :invoice_line_presets, :attorney_fee, :decimal, :precision => 8, :scale => 2
  end
end
