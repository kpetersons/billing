# == Schema Information
# Schema version: 20110619113951
#
# Table name: currencies
#
#  id         :integer(4)      not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Currency < ActiveRecord::Base
  
  has_many :exchange_rates, :order => "id desc"
  
  validates :code, :presence => true
  validates :name, :presence => true
    
  attr_protected :rate
  
  def actual_rate
    exchange_rates.first
  end

  def rate
    exchange_rates.first.rate
  end
  
end
