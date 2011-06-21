class AddColumnsToExchangeRate < ActiveRecord::Migration
  def self.up
    add_column :exchange_rates,    :through_date, :date    
  end

  def self.down
    remove_column :exchange_rates,    :through_date    
  end
end
