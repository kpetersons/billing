class CreateLegals < ActiveRecord::Migration
  def self.up
    create_table :legals do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :legals
  end
end
