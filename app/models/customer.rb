# == Schema Information
#
# Table name: customers
#
#  id                      :integer(4)      not null, primary key
#  party_id                :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#  customer_type           :string(255)
#  vat_registration_number :string(255)
#

class Customer < ActiveRecord::Base
  
  belongs_to :party   
  has_many :matters_as_agent,     :class_name=> 'Matter',  :foreign_key =>     :agent_id
  has_many :matters_as_applicant, :class_name=> 'Matter',  :foreign_key => :applicant_id
 
  attr_accessible :party_id, :vat_registration_number, :customer_type  
  validates :vat_registration_number, :uniqueness => true, :allow_nil => true
  
  before_validation :trim_strings
  
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

  def registration_number
    return party.company.registration_number unless party.company.nil?
  end

  def matters        
  end

  def addresses
    party.addresses
  end

  def default_account
    return party.company.default_account
  end

  def invoice_address
    return party.company.invoice_address    
  end

  private

  def trim_strings
    self.vat_registration_number = " #{self.vat_registration_number} ".strip
    if self.vat_registration_number.empty? 
      self.vat_registration_number = nil      
    end
  end  
  
end
