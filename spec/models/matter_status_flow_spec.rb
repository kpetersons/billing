# == Schema Information
#
# Table name: matter_status_flows
#
#  id                    :integer         not null, primary key
#  revert_to_step_id     :integer
#  current_step_id       :integer
#  pass_to_step_id       :integer
#  pass_to_function_id   :integer
#  revert_to_function_id :integer
#  start_state           :boolean         default(FALSE)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

describe MatterStatusFlow do
  pending "add some examples to (or delete) #{__FILE__}"
end
