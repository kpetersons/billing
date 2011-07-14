class CreatePatentSearches < ActiveRecord::Migration
  def self.up
    create_table :patent_searches do |t|
      t.references  :matter
      t.string      :description
      t.string      :patent_eq_numbers
      t.integer     :no_of_patents, :limit => 1.byte
      t.date        :date_of_order

      t.timestamps
    end
  end

  def self.down
    drop_table :patent_searches
  end
end
