require 'spec_helper'

describe Document do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: documents
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  registration_number :string(255)
#  description         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  parent_id           :integer
#  notes               :string(255)
#  version             :integer         default(1)
#  orig_id             :integer
#  date_effective      :date            default(Tue, 25 Dec 2012)
#  date_effective_end  :datetime
#

