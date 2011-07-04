# == Schema Information
# Schema version: 20110619113951
#
# Table name: invoices
#
#  id                :integer(4)      not null, primary key
#  document_id       :integer(4)
#  customer_id       :integer(4)
#  address_id        :integer(4)
#  individual_id     :integer(4)
#  currency_id       :integer(4)
#  exchange_rate_id  :integer(4)
#  discount          :integer(4)
#  our_ref           :string(255)
#  your_ref          :string(255)
#  your_date         :date
#  po_billing        :string(255)
#  finishing_details :string(255)
#  invoice_date      :date
#  created_at        :datetime
#  updated_at        :datetime
#

class Invoice < ActiveRecord::Base

  belongs_to :document
  belongs_to :customer
  belongs_to :address
  belongs_to :individual
  belongs_to :currency
  belongs_to :exchange_rate
  has_many   :invoice_lines


  def number
    document.registration_number
  end
  
  def classes
    clazzs.collect {|clazz| clazz.code}.join(',')
  end
  
  def customer_name
    (customer.nil?)? '' : customer.name
  end

end
