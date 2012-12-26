class AddFieldsToMatters2 < ActiveRecord::Migration
  def change
    change_column :trademarks, :non_lv_reg_nr, :string
    change_column :legals, :mark_name, :string
  end
end
