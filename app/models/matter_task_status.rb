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

class MatterTaskStatus < ActiveRecord::Base

  has_many :matter_tasks

  validates :name, :presence => true
  validates :function_id, :presence => true

  def translated_name
    I18n.translate(name)
  end

  def self.all_inclusive
    MatterTaskStatus.all<<MatterType.new(:name => "matters.task.status.all", :id => -1)
  end

end
