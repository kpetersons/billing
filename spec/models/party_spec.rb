# == Schema Information
#
# Table name: parties
#
#  id                 :integer         not null, primary key
#  identifier         :string(255)
#  party_type         :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  version            :integer         default(1)
#  orig_id            :integer
#  date_effective     :date            default(Thu, 29 Dec 2011)
#  date_effective_end :datetime
#

require 'spec_helper'

describe Party do
  pending "add some examples to (or delete) #{__FILE__}"
end
