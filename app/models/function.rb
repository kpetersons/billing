# == Schema Information
#
# Table name: functions
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Function < ActiveRecord::Base
  
  has_many :role_functions
  has_many :roles, :through => :role_functions
    
end
