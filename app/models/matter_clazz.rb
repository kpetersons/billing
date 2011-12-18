# == Schema Information
#
# Table name: matter_clazzs
#
#  id         :integer         not null, primary key
#  matter_id  :integer
#  clazz_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class MatterClazz < ActiveRecord::Base

  belongs_to :matter
  belongs_to :clazz  

  validates :matter_id, :presence => true
  validates :clazz_id, :presence => true

end
