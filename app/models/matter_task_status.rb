# == Schema Information
#
# Table name: matter_task_statuses
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  function_id :integer(4)
#

class MatterTaskStatus < ActiveRecord::Base

  has_many :matter_tasks
    
  validates :name, :presence => true
  validates :function_id, :presence => true  
  
end
