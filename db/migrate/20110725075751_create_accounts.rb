class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :bank
      t.string :bank_code
      t.string :account_number

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
