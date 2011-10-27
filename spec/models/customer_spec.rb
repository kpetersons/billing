# == Schema Information
#
# Table name: customers
#
#  id                      :integer         not null, primary key
#  party_id                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  customer_type           :string(255)
#  vat_registration_number :string(255)
#

require 'spec_helper'

describe Customer do
  pending "add some examples to (or delete) #{__FILE__}"
end
