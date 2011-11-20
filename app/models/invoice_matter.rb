# == Schema Information
#
# Table name: invoice_matters
#
#  id             :integer         not null, primary key
#  invoice_id     :integer
#  matter_id      :integer
#  matter_task_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class InvoiceMatter < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :matter_task  
  belongs_to :invoices, :class_name => "VInvoices", :foreign_key => :invoice_id

  validates :matter_id, :presence => true
  validates :invoice_id, :presence => true
  
end
