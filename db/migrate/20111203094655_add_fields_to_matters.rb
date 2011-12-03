class AddFieldsToMatters < ActiveRecord::Migration
  def change
    add_column :trademarks, :registration_date, :date
    add_column :patents, :registration_date, :date
    add_column :designs, :registration_date, :date

    add_column :legals, :date_of_order, :date
    add_column :legals, :court_ref, :text

    add_column :customs, :vid_ref, :text
  end
end
