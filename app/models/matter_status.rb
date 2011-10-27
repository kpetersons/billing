# == Schema Information
#
# Table name: matter_statuses
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  function_id :integer
#

class MatterStatus < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :function_id, :presence => true
    
end
