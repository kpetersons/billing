class RenameTableTrademarkClazz < ActiveRecord::Migration
  def self.up
    rename_column :trademark_clazzs, :trademark_id, :matter_id
    rename_table :trademark_clazzs, :matter_clazzs
  end

  def self.down
  end
end
