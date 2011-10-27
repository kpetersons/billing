# == Schema Information
#
# Table name: address_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  built_in   :boolean
#  created_at :datetime
#  updated_at :datetime
#  party_id   :integer
#

require 'spec_helper'

describe AddressType do
  pending "add some examples to (or delete) #{__FILE__}"
end
