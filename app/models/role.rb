# == Schema Information
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Role < ActiveRecord::Base
  
  has_many :user_roles
  has_many :users, :through => :user_roles
  has_many :role_functions
  has_many :functions, :through => :role_functions
  
  validates :name, :presence => true
  
end
