# == Schema Information
# Schema version: 20110619113951
#
# Table name: exchange_rates
#
#  id          :integer(4)      not null, primary key
#  currency_id :integer(4)
#  rate        :decimal(8, 3)
#  from_date   :date
#  created_at  :datetime
#  updated_at  :datetime
#

class ExchangeRate < ActiveRecord::Base
  
  belongs_to :currency
  
  validates :rate, :presence => true
  validates :rate, :numericality => true
  validates :from_date, :presence => true
  
end