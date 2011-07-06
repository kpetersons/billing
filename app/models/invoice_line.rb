# == Schema Information
#
# Table name: invoice_lines
#
#  id                   :integer(4)      not null, primary key
#  invoice_id           :integer(4)
#  official_fee_type_id :integer(4)
#  official_fee         :string(255)
#  attorney_fee         :string(255)
#  details              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  attorney_fee_type_id :integer(4)
#

class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type
end
