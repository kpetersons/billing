class AddAuthorNameColumnToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :author_name, :string
  end
end
