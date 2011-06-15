class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :source_party_id  
      t.integer :target_party_id
      t.references :relationship_type
      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
