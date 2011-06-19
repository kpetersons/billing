# == Schema Information
# Schema version: 20110619083917
#
# Table name: clazzs
#
#  id         :integer(4)      not null, primary key
#  code       :integer(4)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Clazz < ActiveRecord::Base
  
  has_many :matter_clazzs
  has_many :matters, :through => :matter_clazzs
    
end
