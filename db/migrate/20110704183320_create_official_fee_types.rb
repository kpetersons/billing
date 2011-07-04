class CreateOfficialFeeTypes < ActiveRecord::Migration
  def self.up
    create_table :official_fee_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :official_fee_types
  end
end
