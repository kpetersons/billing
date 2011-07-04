class AddColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users,    :operating_party_id, :integer
  end

  def self.down
    remove_column :users,    :operating_party_id    
  end
end
