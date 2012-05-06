class CreateMatterIndexes < ActiveRecord::Migration
  def up
    change_table :documents do |d|
      d.index :registration_number
    end

    change_table :matters do |d|
      d.index :document_id
      d.index [:orig_id, :version]
      d.index :author_id
    end

    change_table :invoices do |d|
      d.index :document_id
    end

    change_table :matter_tasks do |d|
      d.index :matter_id
    end

    change_table :invoice_lines do |d|
      d.index :invoice_id
    end

    change_table :invoice_matters do |d|
      d.index :invoice_id
      d.index :matter_id
      d.index :matter_task_id
    end
  end

  def down
  end
end
