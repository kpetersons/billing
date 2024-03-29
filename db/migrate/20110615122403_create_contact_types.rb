class CreateContactTypes < ActiveRecord::Migration
  def self.up
    create_table :contact_types do |t|
      t.string :name
      t.boolean :built_in

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_types
  end
end
