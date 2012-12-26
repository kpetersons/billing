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
  has_many :addresses, :dependent => :delete_all
  has_many :contacts, :dependent => :delete_all

  attr_accessible :identifier, :party_type, :individual_attributes, :contact_person_attributes, :company_attributes, :customer_attributes, :address_attributes, :user_attributes, :orig_id, :date_effective, :date_effective_end
  accepts_nested_attributes_for :individual, :company, :customer, :addresses, :contact_person

  validates :identifier, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :date_effective, :date_not_far_future => true
  validates :date_effective_end, :date_not_far_future => true

  before_validation :generate_identifier, :on => :create
  #before_validation :original_no_longer_used
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

  def copy_addresses _addresses
    _addresses.each do |_address|
      copy_address _address
    end
  end

  def copy_address _address
    _new =_address.dup
    _new.assign_attributes( {:orig_id => _address.id})
    _address.update_attribute(:date_effective_end, DateTime.current)
    self.addresses<<_new
  end

  def copy_contacts _contacts
    _contacts.each do |_contact|
      copy_contact _contact
    end
  end

  def copy_contact _contact
    _new =_contact.dup
    _new.assign_attributes( {:orig_id => _contact.id})
    self.contact<< _new
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
    other = self.dup
    other.company = self.company.deep_dup
    other.customer = self.customer.deep_dup
    return other
  end

  def no_longer_used
    update_attribute(:date_effective_end, DateTime.current)
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

  def original_no_longer_used
    originals = Party.find_all_by_orig_id orig_id
    originals.each do |original|
      original.no_longer_used unless original.id == self.id
    end
  end

end

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
#  date_effective     :date            default(Tue, 25 Dec 2012)
#  date_effective_end :datetime
#

