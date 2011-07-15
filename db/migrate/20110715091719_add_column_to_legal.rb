class AddColumnToLegal < ActiveRecord::Migration
  def self.up
    add_column :legals, :opposite_party_id, :integer
    add_column :legals, :opposite_party_agent_id, :integer
    remove_column :legals, :opposite_party
    remove_column :legals, :opposite_party_agent    
  end

  def self.down
    remove_column :legals, :opposite_party_id, :integer
    remove_column :legals, :opposite_party_agent_id, :integer
    add_column :legals, :opposite_party, :integer
    add_column :legals, :opposite_party_agent, :integer
  end
end
