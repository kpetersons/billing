class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.references :party
      t.references :address_type
      t.string :country
      t.string :city
      t.string :street
      t.string :house_number
      t.string :room_number
      t.string :post_code
      t.string :po_box

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
