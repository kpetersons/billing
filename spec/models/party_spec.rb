require 'spec_helper'

describe Party do
  pending "add some examples to (or delete) #{__FILE__}"
end

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
#  date_effective     :date            default(Tue, 25 Dec 2012)
#  date_effective_end :datetime
#

