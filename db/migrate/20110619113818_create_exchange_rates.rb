class CreateExchangeRates < ActiveRecord::Migration
  def self.up
    create_table :exchange_rates do |t|
      t.references :currency
      t.decimal :rate, :precision => 8, :scale => 3
      t.date    :from_date

      t.timestamps
    end
  end

  def self.down
    drop_table :exchange_rates
  end
end
