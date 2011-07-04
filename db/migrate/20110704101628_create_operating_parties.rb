class CreateOperatingParties < ActiveRecord::Migration
  def self.up
    create_table :operating_parties do |t|
      t.references :company
      t.references :operating_party

      t.timestamps
    end
  end

  def self.down
    drop_table :operating_parties
  end
end
