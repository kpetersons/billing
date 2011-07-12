class ChangeMatterColumn < ActiveRecord::Migration
  def self.up
		remove_column :customs, :matter_id
		remove_column :legals, :matter_id
    add_column :legals, :matter_id, :integer
    add_column :customs, :matter_id, :integer		
  end

  def self.down
    add_column :legals, :matter_id, :integer
		add_column :customs, :matter_id, :integer
  end
end
