require 'spec_helper'

describe Customer do
  pending "add some examples to (or delete) #{__FILE__}"
end

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
#  version                 :integer         default(1)
#  orig_id                 :integer
#  date_effective          :date            default(Tue, 25 Dec 2012)
#  date_effective_end      :datetime
#  shortnote               :text
#

