class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :functions
  end
end
