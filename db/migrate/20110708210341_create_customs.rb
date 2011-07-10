class CreateCustoms < ActiveRecord::Migration
  def self.up
    create_table :customs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :customs
  end
end
