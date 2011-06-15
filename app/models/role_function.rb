# == Schema Information
# Schema version: 20110615122529
#
# Table name: role_functions
#
#  id          :integer(4)      not null, primary key
#  role_id     :integer(4)
#  function_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class RoleFunction < ActiveRecord::Base
  
  belongs_to :role
  belongs_to :function
  
end
