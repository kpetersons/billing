class AddColumnToLegalType < ActiveRecord::Migration
  def self.up
    remove_column :legal_types, :name
		add_column :legal_types, :name, :string
		#add_column :legal_types, :description, :string
  end

  def self.down
		remove_column :legal_types, :description
		remove_column :legal_types, :name
  end
end
