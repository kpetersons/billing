# == Schema Information
# Schema version: 20110610074236
#
# Table name: matter_task_statuses
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MatterTaskStatus < ActiveRecord::Base

  attr_accessible :name

  has_many :matter_tasks

end
