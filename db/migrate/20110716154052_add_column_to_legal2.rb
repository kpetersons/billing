class AddColumnToLegal2 < ActiveRecord::Migration
  def self.up
		remove_column :legals, :oposing_party_agent_id
		remove_column :legals, :oposing_party_id
  end

  def self.down
		
  end
end
