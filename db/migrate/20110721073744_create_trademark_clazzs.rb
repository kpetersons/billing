class CreateTrademarkClazzs < ActiveRecord::Migration
  def self.up
    create_table :trademark_clazzs do |t|
      t.references :trademark
      t.references :clazz
      t.timestamps
    end
    
    drop_table :matter_clazzs
        
  end

  def self.down
    drop_table :trademark_clazzs
  end
end
