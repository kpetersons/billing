class AddMatterColumns < ActiveRecord::Migration
  def self.up
    add_column :trademarks, :matter_id, :integer
    add_column :patents,    :matter_id, :integer
    add_column :designs,    :matter_id, :integer
    add_column :legals,     :matter_id, :string
    add_column :customs,    :matter_id, :string
  end

  def self.down
    remove_column :customs, :matter_id
    remove_column :legals, :matter_id
    remove_column :designs, :matter_id
    remove_column :patents, :matter_id
    remove_column :trademarks, :matter_id
  end
end
