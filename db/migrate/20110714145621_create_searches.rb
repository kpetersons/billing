class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.references  :matter
      t.string      :search_for
      t.integer     :no_of_objects, :limit => 1.byte
      t.boolean     :express_search
      t.date        :date_of_order

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
