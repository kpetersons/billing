# == Schema Information
# Schema version: 20110619083917
#
# Table name: matter_clazzs
#
#  id         :integer(4)      not null, primary key
#  matter_id  :integer(4)
#  clazz_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class MatterClazz < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :clazz
  
end
