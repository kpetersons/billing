class AddFieldsToMatters1 < ActiveRecord::Migration
  def change
    add_column :trademarks, :renewal_date, :date
    add_column :trademarks, :non_lv_reg_nr, :text
    add_column :legals, :mark_name, :text
  end
end
