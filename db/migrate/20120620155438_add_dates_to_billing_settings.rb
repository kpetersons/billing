class AddDatesToBillingSettings < ActiveRecord::Migration
  def change
    change_table :billing_settings do |t|
      t.date :activated_when
      t.date :deactivated_when
    end
  end
end
