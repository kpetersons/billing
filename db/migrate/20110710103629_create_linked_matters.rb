class CreateLinkedMatters < ActiveRecord::Migration
  def self.up
    create_table :linked_matters do |t|
      t.integer  :matter_id
      t.integer  :linked_matter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :linked_matters
  end
end
