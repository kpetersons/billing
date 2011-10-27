class ChangePatentEpNumberToNumber < ActiveRecord::Migration
  def self.up
    remove_column  :patents, :ep_number
    add_column  :patents, :ep_number, :integer
  end

  def self.down
  end
end
