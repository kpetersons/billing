class AddFieldsToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :suspended, :boolean
  end
end
