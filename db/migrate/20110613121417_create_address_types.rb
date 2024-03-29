class CreateAddressTypes < ActiveRecord::Migration
  def self.up
    create_table :address_types do |t|
      t.string :name
      t.boolean :built_in

      t.timestamps
    end
  end

  def self.down
    drop_table :address_types
  end
end
