class CreateRoleFunctions < ActiveRecord::Migration
  def self.up
    create_table :role_functions do |t|
      t.references :role
      t.references :function

      t.timestamps
    end
  end

  def self.down
    drop_table :role_functions
  end
end
