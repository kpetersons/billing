class AddShortnoteToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :shortnote, :text
  end

  def self.down
    remove_column :customers, :shortnote
  end
end
