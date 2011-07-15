class AddColumnToDocument < ActiveRecord::Migration
  def self.up
		add_column :documents, :notes, :string
  end

  def self.down
		remove_column :documents, :notes
  end
end
