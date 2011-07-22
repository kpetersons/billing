# == Schema Information
#
# Table name: invoice_statuses
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  function_id    :integer(4)
#  editable_state :boolean(1)
#

class InvoiceStatus < ActiveRecord::Base
  
  belongs_to :function
  has_many :invoices
  
  validates :name, :presence => true
  validates :function_id, :presence => true
    
end
