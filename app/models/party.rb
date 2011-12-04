# == Schema Information
#
# Table name: parties
#
#  id                 :integer         not null, primary key
#  identifier         :string(255)
#  party_type         :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  version            :integer         default(1)
#  orig_id            :integer
#  date_effective     :date            default(Sat, 03 Dec 2011)
#  date_effective_end :datetime
#

class Party < ActiveRecord::Base

  has_one :company, :foreign_key => :party_id, :autosave => true, :dependent => :delete
  has_one :customer, :foreign_key => :party_id, :autosave => true, :dependent => :delete
  has_one :individual, :foreign_key => :party_id, :autosave => true, :dependent => :delete
  has_one :contact_person, :foreign_key => :party_id, :autosave => true, :dependent => :delete

  has_many :source_relationships, :class_name => 'Relationship', :foreign_key => :source_party_id, :dependent => :delete_all
  has_many :target_relationships, :class_name => 'Relationship', :foreign_key => :target_party_id, :dependent => :delete_all
  #
  has_many :source_parties, :class_name => 'Party', :through => :source_relationships
  has_many :target_parties, :class_name => 'Party', :through => :target_relationships
  #
  has_many :addresses, :conditions => "date_effective_end is null", :primary_key => :orig_id, :dependent => :delete_all
  has_many :contacts, :dependent => :delete_all

  attr_accessible :identifier, :party_type, :individual_attributes, :contact_person_attributes, :company_attributes, :customer_attributes, :address_attributes, :user_attributes, :orig_id, :date_effective, :date_effective_end
  accepts_nested_attributes_for :individual, :company, :customer, :addresses, :contact_person

  validates :identifier, :uniqueness => {:case_sensitive => false}, :presence => true

  before_validation :generate_identifier, :on => :create
  after_create :set_orig_id

  def active_addresses
    addresses.where(:date_effective_end => nil).all
  end

  def target_parties (relationship_type)
    return target_parties_query(:relationship_type => relationship_type).all
  end

  def target_parties_query(relationship_type)
    return Party.joins(:target_relationships => :relationship_type).where(:relationships => {:source_party_id => id})
  end

  def source_parties (relationship_type)
    return source_parties_query(:relationship_type => relationship_type).all
  end

  def source_parties_query(relationship_type)
    return Party.joins(:source_relationships => :relationship_type).where(:relationships => {:target_party_id => id})
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

  def self.new_copy params
    original = Party.find(params[:id])
    params_copy = params.reject { |x| false }
    params_copy.reject! { |x| x.eql?("id") }
    params_copy[:company_attributes].reject! { |x| x.eql?("id") }
    params_copy[:customer_attributes].reject! { |x| x.eql?("id") }
    party = Party.new(params_copy)
    return party
  end

  def deep_dup
    other = Party.new
    other.attributes = attributes
    other.id = nil
    other.build_company(company.attributes)
    other.company.id = nil
    other.company.party_id = nil
    other.build_customer(customer.attributes)
    other.customer.id = nil
    other.customer.party_id = nil
    return other
  end

  def no_longer_used
    date_effective_end = DateTime.current
    customer.date_effective_end = DateTime.current
    company.date_effective_end = DateTime.current
  end

  private
  def generate_identifier
    self.identifier = UUIDTools::UUID.random_create.to_s
  end

  def set_orig_id
    if self.orig_id.nil?
      update_attribute(:orig_id, self.id)
    end
  end

end
