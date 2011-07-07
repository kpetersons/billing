# == Schema Information
#
# Table name: matter_type_statuss_flows
#
#  id                :integer(4)      not null, primary key
#  revert_to_step_id :integer(4)
#  current_step_id   :integer(4)
#  pass_to_step_id   :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe MatterTypeStatussFlow do
  pending "add some examples to (or delete) #{__FILE__}"
end
