class AddFieldsToMatters3 < ActiveRecord::Migration
  def change
    add_column :trademarks, :publication_date, :date
  end
end
