class CreateMatters < ActiveRecord::Migration
  def self.up
    create_table :matters do |t|
      t.references :document
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :matters
  end
end
