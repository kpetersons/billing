class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.references  :matter
      t.string      :domain_name
      t.date        :registration_date

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
