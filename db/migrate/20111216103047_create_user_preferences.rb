class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.integer :rows_per_page
      t.references :user
      t.timestamps
    end
  end
end
