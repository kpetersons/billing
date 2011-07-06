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

require 'spec_helper'

describe InvoiceLine do
  pending "add some examples to (or delete) #{__FILE__}"
end
