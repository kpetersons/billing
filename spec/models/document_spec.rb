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
#

require 'spec_helper'

describe Document do
  pending "add some examples to (or delete) #{__FILE__}"
end
