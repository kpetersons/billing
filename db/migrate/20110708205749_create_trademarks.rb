class CreateTrademarks < ActiveRecord::Migration
  def self.up
    create_table :trademarks do |t|
      t.date :appl_date
      t.string :appl_number
      t.timestamps
    end
  end

  def self.down
    drop_table :trademarks
  end
end
