class AddColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :login_date, :datetime
    add_column :users, :last_login_date, :datetime
  end

  def self.down
  end
end
