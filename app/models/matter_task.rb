# == Schema Information
#
# Table name: matter_tasks
#
#  id                         :integer(4)      not null, primary key
#  matter_id                  :integer(4)
#  matter_task_status_id      :integer(4)
#  description                :string(255)
#  proposed_deadline          :date
#  created_at                 :datetime
#  updated_at                 :datetime
#  author_id                  :integer(4)
#  matter_task_status_flow_id :integer(4)
#

class MatterTask < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :matter_task_status
  belongs_to :flow_state, :class_name => "MatterTaskStatusFlow", :foreign_key => :matter_task_status_flow_id 
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  has_many   :invoice_matters
  has_many   :invoices, :through => :invoice_matters
  
  
#  attr_accessible :matter_id, :matter_task_status_id, :description, :proposed_deadline
  
  validates :description, :presence => true
  validates :proposed_deadline, :presence => true
  
  def status
    (matter_task_status.nil?)? '' : matter_task_status.name 
  end
  
end
