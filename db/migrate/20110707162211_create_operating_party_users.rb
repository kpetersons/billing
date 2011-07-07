class CreateOperatingPartyUsers < ActiveRecord::Migration
  def self.up
    create_table :operating_party_users do |t|
      t.references :user
      t.references :operating_party

      t.timestamps
    end
  end

  def self.down
    drop_table :operating_party_users
  end
end
