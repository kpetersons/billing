# == Schema Information
#
# Table name: trademark_clazzs
#
#  id           :integer(4)      not null, primary key
#  trademark_id :integer(4)
#  clazz_id     :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class TrademarkClazz < ActiveRecord::Base

  belongs_to :trademark
  belongs_to :clazz  
  
end
