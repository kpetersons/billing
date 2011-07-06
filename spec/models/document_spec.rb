# == Schema Information
#
# Table name: documents
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  registration_number :string(255)
#  description         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  parent_id           :integer(4)
#

require 'spec_helper'

describe Document do
  pending "add some examples to (or delete) #{__FILE__}"
end
