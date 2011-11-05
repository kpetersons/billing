# == Schema Information
#
# Table name: official_fee_types
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  description        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  operating_party_id :integer
#  apply_vat          :boolean
#  apply_discount     :boolean
#

require 'spec_helper'

describe OfficialFeeType do
  pending "add some examples to (or delete) #{__FILE__}"
end
