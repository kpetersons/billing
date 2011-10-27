# == Schema Information
#
# Table name: currencies
#
#  id         :integer         not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Currency < ActiveRecord::Base
    
  validates :code, :presence => true
  validates :name, :presence => true    
   
end
