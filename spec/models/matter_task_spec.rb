# == Schema Information
#
# Table name: matter_tasks
#
#  id                    :integer(4)      not null, primary key
#  matter_id             :integer(4)
#  matter_task_status_id :integer(4)
#  description           :string(255)
#  proposed_deadline     :date
#  created_at            :datetime
#  updated_at            :datetime
#  author_id             :integer(4)
#  matter_task_type_id   :integer(4)
#

require 'spec_helper'

describe MatterTask do
  pending "add some examples to (or delete) #{__FILE__}"
end
