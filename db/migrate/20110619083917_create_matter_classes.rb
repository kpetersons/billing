class CreateMatterClasses < ActiveRecord::Migration
  def self.up
    create_table :matter_clazzs do |t|
      t.references :matter
      t.references :clazz

      t.timestamps
    end
  end

  def self.down
    drop_table :matter_clazzs
  end
end
