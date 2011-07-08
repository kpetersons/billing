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

class MatterTaskStatus < ActiveRecord::Base

  has_many :matter_tasks
    
  validates :name, :presence => true
  validates :revert_to_name, :presence => true  
  validates :pass_to_name, :presence => true  
  
end
