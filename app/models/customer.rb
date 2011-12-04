# == Schema Information
#
# Table name: customers
#
#  id                      :integer         not null, primary key
#  party_id                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  customer_type           :string(255)
#  vat_registration_number :string(255)
#  version                 :integer         default(1)
#  orig_id                 :integer
#  date_effective          :date            default(Sat, 03 Dec 2011)
#  date_effective_end      :datetime
#  shortnote               :text
#

class Customer < ActiveRecord::Base

  belongs_to :party
  has_many :matters_as_agent, :class_name=> 'VMatters', :foreign_key => :agent_id
  has_many :matters_as_applicant, :class_name=> 'VMatters', :foreign_key => :applicant_id

  attr_accessible :vat_registration_number, :customer_type, :shortnote, :orig_id, :party_id, :date_effective, :date_effective_end
  validate :vat_registration_number_unique

  before_validation :trim_strings
  after_create :set_orig_id

  def history
    Customer.where(:orig_id => orig_id).where("date_effective_end is not null and id < ?", id).order(:id)
  end

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
    Individual.where(:party_id => party.target_parties_query(:relationship_type => RelationshipType.find_by_name('CONTACT_PERSON').id))
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
    return party.company.default_account unless party.company.default_account.nil?
    return Account.new
  end

  def invoice_address
    return party.company.invoice_address
  end

  def inv_address
    return party.company.inv_address unless party.company.inv_address.nil?
    return Address.new
  end

  def self.quick_search query, page
    where(:date_effective_end => nil).joins(:party => [:company]).paginate :per_page => 10, :page => page,
                                                                           :conditions => ['vat_registration_number like :q or name ilike :q',
                                                                                           {:q => "%#{query}%", :gi => query}]
  end

  private

  def trim_strings
    self.vat_registration_number = " #{self.vat_registration_number} ".strip
    if self.vat_registration_number.empty?
      self.vat_registration_number = nil
    end
  end

  def set_orig_id
    if self.orig_id.nil?
      update_attribute(:orig_id, self.id)
    end
  end

  def vat_registration_number_unique
    if persisted?
      test =Customer.where("orig_id != ? and vat_registration_number = ? and date_effective_end is null", orig_id, vat_registration_number).first
      if !test.nil?
        puts "test.attributes #{test.attributes}"
        errors.add :vat_registration_number, "should be unique!"
      end
    else
      test = Customer.where("vat_registration_number = ? and date_effective_end is null", vat_registration_number).first
      if !test.nil?
        puts "test.attributes #{test.attributes}"
        errors.add :vat_registration_number, "should be unique!"
      end
    end
  end

end
