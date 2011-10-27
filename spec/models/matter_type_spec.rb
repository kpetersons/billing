# == Schema Information
#
# Table name: matter_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  function_id :integer
#

require 'spec_helper'

describe MatterType do
  pending "add some examples to (or delete) #{__FILE__}"
end
