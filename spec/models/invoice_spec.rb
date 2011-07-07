# == Schema Information
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
#  author_id         :integer(4)
#

require 'spec_helper'

describe Invoice do
  pending "add some examples to (or delete) #{__FILE__}"
end
