class ChangeDateEffectiveColumn < ActiveRecord::Migration
  def up
    change_column :matters,   :date_effective, :date, :default => Date.current
    change_column :customers, :date_effective, :date, :default => Date.current
    change_column :addresses, :date_effective, :date, :default => Date.current
    change_column :companies, :date_effective, :date, :default => Date.current
    change_column :documents, :date_effective, :date, :default => Date.current
    change_column :parties,   :date_effective, :date, :default => Date.current
  end

  def down
  end
end
