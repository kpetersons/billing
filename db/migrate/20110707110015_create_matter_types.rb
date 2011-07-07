class CreateMatterTypes < ActiveRecord::Migration
  def self.up
    create_table :matter_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end    
		add_column :matters, :matter_type_id, :integer
    add_column :matters, :operating_party_id, :integer    		
    create_table :operating_party_matter_types do |t|
      t.references :operating_party      
      t.references :matter_type
      t.timestamps
    end    		
  end

  def self.down
		remove_column :matters, :matter_type_id
    remove_column :matters, :operating_party_id		
    drop_table :matter_types
    drop_table :operating_party_matter_types
  end
end