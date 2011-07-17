class RemoveColumnFromAddress < ActiveRecord::Migration
  def self.up
    remove_column :addresses, :country
  end

  def self.down
    add_column :addresses, :country, :string
  end
end
