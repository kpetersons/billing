class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.references :party      
      t.date :customer_since

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
