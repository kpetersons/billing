# == Schema Information
#
# Table name: matter_statuses
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  function_id :integer(4)
#

require 'spec_helper'

describe MatterStatus do
  pending "add some examples to (or delete) #{__FILE__}"
end
