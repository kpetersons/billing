class CreateIndividuals < ActiveRecord::Migration
  def self.up
    create_table :individuals do |t|
      t.references :party
      t.references :gender
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :birth_date

      t.timestamps
    end
  end

  def self.down
    drop_table :individuals
  end
end
