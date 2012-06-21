# == Schema Information
#
# Table name: v_matter_tasks
#
#  id                  :integer         primary key
#  matter_id           :integer
#  registration_number :text
#  matter_type         :string(255)
#  task_type           :string(255)
#  status              :string(255)
#  description         :text
#  deadline            :date
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe VMatterTasks do
  pending "add some examples to (or delete) #{__FILE__}"
end
