# == Schema Information
#
# Table name: matter_task_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class MatterTaskType < ActiveRecord::Base
  has_many :matter_tasks

  attr_accessible :name, :description

  def self.all_inclusive
    MatterTaskType.all<<MatterTaskType.new(:name => "All", :id => -1)
  end
end
