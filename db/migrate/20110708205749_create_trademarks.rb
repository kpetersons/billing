class CreateTrademarks < ActiveRecord::Migration
  def self.up
    create_table :trademarks do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :trademarks
  end
end