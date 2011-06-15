class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.references :party
      t.references :contact_type      
      t.string :contact_value

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
