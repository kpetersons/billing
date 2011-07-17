# == Schema Information
#
# Table name: matter_status_flows
#
#  id                    :integer(4)      not null, primary key
#  revert_to_step_id     :integer(4)
#  current_step_id       :integer(4)
#  pass_to_step_id       :integer(4)
#  pass_to_function_id   :integer(4)
#  revert_to_function_id :integer(4)
#  start_state           :boolean(1)      default(FALSE)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

describe MatterStatusFlow do
  pending "add some examples to (or delete) #{__FILE__}"
end
