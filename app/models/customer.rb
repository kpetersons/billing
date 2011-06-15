# == Schema Information
# Schema version: 20110612110454
#
# Table name: customers
#
#  id             :integer(4)      not null, primary key
#  party_id       :integer(4)
#  customer_since :date
#  created_at     :datetime
#  updated_at     :datetime
#  customer_type  :string(255)
#

class Customer < ActiveRecord::Base
  
  belongs_to :party   
  has_many :matters_as_agent,     :class_name=> 'Matter',  :foreign_key =>     :agent_id
  has_many :matters_as_applicant, :class_name=> 'Matter',  :foreign_key => :applicant_id  
 
  attr_accessible :party_id, :customer_since, :customer_type
  
  validates :customer_since, :presence => true
  
  def name
    return party.try(:company).try(:name)
  end  
  
  def type
    return (party.individual.nil?) ? party.company.class : party.individual.class
  end  
  
  def identifier
    return party.identifier
  end
  
  def contact_persons
    Individual.where(:party_id => party.target_parties_query(:relationship_type => RelationshipType.find_by_name('CONTACT_PERSON').id)).all
  end

  def matters
        
  end
  
end
