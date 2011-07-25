class AddColumnToAccount1 < ActiveRecord::Migration
  def self.up
    add_column :accounts, :default_account, :boolean
    add_column :accounts, :show_on_invoice, :boolean
  end

  def self.down
  end
end
