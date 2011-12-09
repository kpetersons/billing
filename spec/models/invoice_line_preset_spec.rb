# == Schema Information
#
# Table name: invoice_line_presets
#
#  id                   :integer         not null, primary key
#  operating_party_id   :integer
#  official_fee_type_id :integer
#  attorney_fee_type_id :integer
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  author_id            :integer
#  private_preset       :boolean
#  official_fee         :decimal(8, 2)
#  attorney_fee         :decimal(8, 2)
#  currency_id          :integer
#  orig_id              :integer
#  date_effective       :date
#  date_effective_end   :date
#

require 'spec_helper'

describe InvoiceLinePreset do
  pending "add some examples to (or delete) #{__FILE__}"
end
