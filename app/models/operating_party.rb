# == Schema Information
# Schema version: 20110704183314
#
# Table name: operating_parties
#
#  id                 :integer(4)      not null, primary key
#  company_id         :integer(4)
#  operating_party_id :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class OperatingParty < ActiveRecord::Base
  
  belongs_to :company;
  belongs_to :parent_operating_party, :class_name => "OperatingParty", :foreign_key => "operating_party_id"
  has_many :operating_parties, :class_name => "OperatingParty", :foreign_key => "operating_party_id"
  has_many :users, :foreign_key => "operating_party_id"

  def party
    company.party
  end

  def name
    company.name
  end

  def parent_name
    parent_operating_party.company.name unless parent_operating_party.nil? 
  end
  
  def identifier 
    company.party.identifier
  end
  
end
