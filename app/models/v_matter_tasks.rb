# == Schema Information
#
# Table name: v_matter_tasks
#
#  registration_number :string(255)
#  matter_type         :string(255)
#  id                  :integer         primary key
#  matter_id           :integer
#  status              :string(255)
#  description         :text
#  deadline            :date
#  created_at          :datetime
#  updated_at          :datetime
#

class VMatterTasks < ActiveRecord::Base

end
