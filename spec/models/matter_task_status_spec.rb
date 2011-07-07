# == Schema Information
#
# Table name: matter_task_statuses
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  revert_to_name :string(255)
#  pass_to_name   :string(255)
#

require 'spec_helper'

describe MatterTaskStatus do
  pending "add some examples to (or delete) #{__FILE__}"
end
