class ChangeVersionColumn < ActiveRecord::Migration
  def up
    change_column :matters,   :version, :integer, :default => 1
    change_column :customers, :version, :integer, :default => 1
    change_column :addresses, :version, :integer, :default => 1
    change_column :companies, :version, :integer, :default => 1
    change_column :documents, :version, :integer, :default => 1
    change_column :parties,   :version, :integer, :default => 1
  end

  def down
  end
end
