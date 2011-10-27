# == Schema Information
#
# Table name: invoice_statuses
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  function_id    :integer
#  editable_state :boolean
#

class InvoiceStatus < ActiveRecord::Base
  
  belongs_to :function
  has_many :invoices
  
  validates :name, :presence => true
  validates :function_id, :presence => true
    
end
