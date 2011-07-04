class AddColumnToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :registration_number, :string
  end

  def self.down
    remove_column :companies, :registration_number
  end
end
