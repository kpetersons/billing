class AddColumnsToDocumentTags < ActiveRecord::Migration
  def self.up
    add_column :document_tags,    :document_id,    :integer
    add_column :document_tags,    :tag_id,    :integer    
  end

  def self.down
    remove_column :document_tags,    :document_id,    :integer
    remove_column :document_tags,    :tag_id,    :integer    
  end
end
