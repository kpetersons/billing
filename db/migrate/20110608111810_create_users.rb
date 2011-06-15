class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.references :individual
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.boolean :active
      t.boolean :blocked
      t.date :registration_date
      t.string :activation_key

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
