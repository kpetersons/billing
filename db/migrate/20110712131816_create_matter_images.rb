class CreateMatterImages < ActiveRecord::Migration
  def self.up
    create_table :matter_images do |t|
      t.references  :matter
      t.string      :image_file_name
      t.string      :image_content_type
      t.integer     :image_file_size
      t.datetime    :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :matter_images
  end
end
