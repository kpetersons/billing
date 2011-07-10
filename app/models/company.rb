# == Schema Information
# Schema version: 20110704183314
#
# Table name: companies
#
#  id                  :integer(4)      not null, primary key
#  party_id            :integer(4)
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  registration_number :string(255)
#

class Company < ActiveRecord::Base
    belongs_to :party
    has_one :operating_party
     
    attr_accessible :party_id, :name, :operating_party_attributes, :registration_number
    accepts_nested_attributes_for :operating_party    
        
    validates :name, :presence => true
#    validates :registration_number, :uniqueness => true
    
    before_save :trim_strings

  private

  def trim_strings
    unless registration_number.nil?
#      registration_number = registration_number.strip      
    end    
    if !registration_number.nil? && registration_number.empty?
      registration_number = nil
    end    
  end  

end
