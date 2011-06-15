# == Schema Information
# Schema version: 20110610074236
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
#

class MatterTask < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :matter_task_status
  
  attr_accessible :matter_id, :matter_task_status_id, :description, :proposed_deadline
  
  validates :description, :presence => true
  validates :proposed_deadline, :presence => true
  
  def status
    (matter_task_status.nil?)? '' : matter_task_status.name 
  end
  
end
