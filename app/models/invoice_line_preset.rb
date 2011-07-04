# == Schema Information
# Schema version: 20110704185444
#
# Table name: invoice_line_presets
#
#  id                    :integer(4)      not null, primary key
#  operating_party_id    :integer(4)
#  official_fee_type_id  :integer(4)
#  attorneys_fee_type_id :integer(4)
#  name                  :string(255)
#  off_fee               :string(255)
#  attorneys_fee         :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class InvoiceLinePreset < ActiveRecord::Base
end
