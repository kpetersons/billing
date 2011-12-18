# == Schema Information
#
# Table name: clazzs
#
#  id         :integer         not null, primary key
#  code       :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Clazz < ActiveRecord::Base
  
  has_many :matter_clazzs
  has_many :matters, :through => :matter_clazzs
    
end
