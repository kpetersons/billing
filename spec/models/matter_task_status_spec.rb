# == Schema Information
#
# Table name: matter_task_statuses
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  function_id :integer
#

require 'spec_helper'

describe MatterTaskStatus do
  pending "add some examples to (or delete) #{__FILE__}"
end
