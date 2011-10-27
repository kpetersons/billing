# == Schema Information
#
# Table name: parties
#
#  id         :integer         not null, primary key
#  identifier :string(255)
#  party_type :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Party < ActiveRecord::Base
     
  has_one :company, :foreign_key => :party_id, :autosave => true
  has_one :customer, :foreign_key => :party_id, :autosave => true
  has_one :individual, :foreign_key => :party_id, :autosave => true
  has_one :contact_person, :foreign_key => :party_id, :autosave => true  
    
  has_many :source_relationships, :class_name => 'Relationship', :foreign_key => :source_party_id
  has_many :target_relationships, :class_name => 'Relationship', :foreign_key => :target_party_id
  #
  has_many :source_parties, :class_name => 'Party', :through => :source_relationships
  has_many :target_parties, :class_name => 'Party', :through => :target_relationships  
  #
  has_many :addresses
  has_many :contacts
  
  attr_accessible :identifier, :party_type, :individual_attributes, :contact_person_attributes, :company_attributes, :customer_attributes, :address_attributes, :user_attributes
  accepts_nested_attributes_for :individual, :company, :customer, :addresses, :contact_person
  
  validates :identifier, :uniqueness       => {:case_sensitive => false}, :presence => true
  
  before_validation :generate_identifier, :on => :create 
  
  def target_parties (relationship_type) 
    return target_parties_query(:relationship_type => relationship_type).all
  end
  
  def target_parties_query(relationship_type)
    return Party
              .joins(:target_relationships => :relationship_type)
              .where(:relationships => {:source_party_id => id})    
  end
  
  def source_parties (relationship_type) 
    return source_parties_query(:relationship_type => relationship_type).all
  end
  
  def source_parties_query(relationship_type)
    return Party
              .joins(:source_relationships => :relationship_type)
              .where(:relationships => {:target_party_id => id})    
  end  

  def outer_object
    unless customer.nil?
      return customer
    end
    unless individual.nil?
      unless individual.user.nil?
        return individual.user
      end 
      return individual
    end
  end

  private
  def generate_identifier
#    puts "self.identifier = UUIDTools::UUID.random_create.to_s = #{UUIDTools::UUID.random_create.to_s}"
    self.identifier = UUIDTools::UUID.random_create.to_s
  end
       
end
