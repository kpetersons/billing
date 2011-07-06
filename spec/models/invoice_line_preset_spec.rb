# == Schema Information
#
# Table name: invoice_line_presets
#
#  id                   :integer(4)      not null, primary key
#  operating_party_id   :integer(4)
#  official_fee_type_id :integer(4)
#  attorney_fee_type_id :integer(4)
#  name                 :string(255)
#  official_fee         :string(255)
#  attorney_fee         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe InvoiceLinePreset do
  pending "add some examples to (or delete) #{__FILE__}"
end
