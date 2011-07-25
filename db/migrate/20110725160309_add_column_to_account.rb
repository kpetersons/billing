class AddColumnToAccount < ActiveRecord::Migration
  def self.up
		add_column :accounts, :company_id, :integer
		drop_table :company_accounts
  end

  def self.down
		remove_column :accounts, :company_id
  end
end
