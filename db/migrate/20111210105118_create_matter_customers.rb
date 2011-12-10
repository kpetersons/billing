class CreateMatterCustomers < ActiveRecord::Migration
  def change
    create_table :matter_customers do |t|
      t.references :matter
      t.references :customer
      t.date :takeover_date
      t.string :shortnote
      t.timestamps
    end
  end
end
