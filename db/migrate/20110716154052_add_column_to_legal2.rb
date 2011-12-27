class AddColumnToLegal2 < ActiveRecord::Migration
  def self.up
    add_column :legals, :oposing_party_agent_id, :integer
		remove_column :legals, :oposing_party_agent_id
    add_column :legals, :oposing_party_id, :integer
		remove_column :legals, :oposing_party_id
  end

  def self.down
		
  end
end
