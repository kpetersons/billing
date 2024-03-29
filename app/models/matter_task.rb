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

class MatterTask < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :matter_task_status 
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  belongs_to :matter_task_type
  has_many   :invoice_matters
  has_many   :invoices, :through => :invoice_matters
  
  
#  attr_accessible :matter_id, :matter_task_status_id, :description, :proposed_deadline
  
  validates :description, :presence => true, :length => {:in => 1..255}
  validates :proposed_deadline, :presence => true
  validates :proposed_deadline, :date_not_far_future => true

  def linked_invoices

  end

  def status_name
    matter_task_status.name unless matter_task_status.nil?
  end

  def type_name
    matter_task_type.name unless matter_task_type.nil? 
  end

  def available_statuses
    MatterTaskStatus.where("id != ?", [matter_task_status_id]).all
  end
  
end
