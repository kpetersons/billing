# == Schema Information
#
# Table name: official_fee_types
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  description        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  operating_party_id :integer(4)
#

require 'spec_helper'

describe OfficialFeeType do
  pending "add some examples to (or delete) #{__FILE__}"
end
