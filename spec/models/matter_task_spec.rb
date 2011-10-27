# == Schema Information
#
# Table name: matter_tasks
#
#  id                    :integer         not null, primary key
#  matter_id             :integer
#  matter_task_status_id :integer
#  description           :string(255)
#  proposed_deadline     :date
#  created_at            :datetime
#  updated_at            :datetime
#  author_id             :integer
#  matter_task_type_id   :integer
#

require 'spec_helper'

describe MatterTask do
  pending "add some examples to (or delete) #{__FILE__}"
end
