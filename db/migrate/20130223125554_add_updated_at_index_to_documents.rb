class AddUpdatedAtIndexToDocuments < ActiveRecord::Migration
  def change
    add_index :documents, :updated_at, {:unique => false}
  end
end
