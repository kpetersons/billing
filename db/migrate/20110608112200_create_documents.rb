class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.references :user      
      t.string :registration_number
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
