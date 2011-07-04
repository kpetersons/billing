class CreateAttorneysFeeTypes < ActiveRecord::Migration
  def self.up
    create_table :attorneys_fee_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :attorneys_fee_types
  end
end
