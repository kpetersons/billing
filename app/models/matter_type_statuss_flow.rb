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

class MatterTypeStatussFlow < ActiveRecord::Base
end
