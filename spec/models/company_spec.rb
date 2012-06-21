# == Schema Information
#
# Table name: companies
#
#  id                  :integer         not null, primary key
#  party_id            :integer
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  registration_number :string(255)
#  version             :integer         default(1)
#  orig_id             :integer
#  date_effective      :date            default(Thu, 29 Dec 2011)
#  date_effective_end  :datetime
#

require 'spec_helper'

describe Company do
  pending "add some examples to (or delete) #{__FILE__}"
end
