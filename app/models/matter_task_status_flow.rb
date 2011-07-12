# == Schema Information
#
# Table name: matter_task_status_flows
#
#  id                    :integer(4)      not null, primary key
#  revert_to_step_id     :integer(4)
#  current_step_id       :integer(4)
#  pass_to_step_id       :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#  start_state           :boolean(1)      default(FALSE)
#  pass_to_function_id   :integer(4)
#  revert_to_function_id :integer(4)
#

class MatterTaskStatusFlow < ActiveRecord::Base

  belongs_to :revert_to_step, :class_name => 'MatterTaskStatus', :foreign_key => :revert_to_step_id
  belongs_to :current_step, :class_name => 'MatterTaskStatus', :foreign_key => :current_step_id
  belongs_to :pass_to_step, :class_name => 'MatterTaskStatus', :foreign_key => :pass_to_step_id
  #
  belongs_to :pass_to_function, :class_name => 'Function', :foreign_key => :pass_to_function_id
  belongs_to :revert_to_function, :class_name => 'Function', :foreign_key => :revert_to_function_id  
  
  validates :current_step_id, :presence => true

  def possible_change_states direction
    MatterTaskStatusFlow.select("distinct #{direction}_id, #{direction.to_s.sub('_step', '_function_id')}").where(:current_step_id => current_step_id).group("revert_to_step_id, current_step_id, pass_to_step_id").all
  end 

end
