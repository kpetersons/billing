# == Schema Information
#
# Table name: invoices
#
#  id                :integer         not null, primary key
#  document_id       :integer
#  customer_id       :integer
#  address_id        :integer
#  individual_id     :integer
#  currency_id       :integer
#  exchange_rate_id  :integer
#  discount          :integer
#  our_ref           :string(255)
#  your_ref          :string(255)
#  your_date         :date
#  po_billing        :string(255)
#  finishing_details :string(255)
#  invoice_date      :date
#  created_at        :datetime
#  updated_at        :datetime
#  author_id         :integer
#  exchange_rate     :decimal(7, 4)
#  subject           :string(2000)
#  ending_details    :string(2000)
#  payment_term      :integer(2)
#  apply_vat         :boolean
#  invoice_status_id :integer
#  date_paid         :date
#  foreign_number    :integer
#  local_number      :integer
#  invoice_type      :integer
#

require 'spec_helper'

describe Invoice do
  pending "add some examples to (or delete) #{__FILE__}"
end
