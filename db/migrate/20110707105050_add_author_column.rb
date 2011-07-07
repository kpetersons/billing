class AddAuthorColumn < ActiveRecord::Migration
  def self.up
    add_column :matters,       :author_id, :integer
    add_column :matter_tasks,  :author_id, :integer
    add_column :invoices,      :author_id, :integer
    add_column :invoice_lines, :author_id, :integer
		add_column :invoice_line_presets, :author_id, :integer
		add_column :invoice_line_presets, :private_preset, :boolean
  end

  def self.down
		remove_column :invoice_line_presets, :private_preset
		remove_column :invoice_line_presets, :author_id
    remove_column :invoice_lines, :author_id
    remove_column :invoices, :author_id
    remove_column :matter_tasks, :author_id
    remove_column :matters, :author_id
  end
end
