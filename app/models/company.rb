# == Schema Information
#
# Table name: companies
#
#  id                  :integer         not null, primary key
#  party_id            :integer
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  registration_number :string(255)
#  version             :integer         default(1)
#  orig_id             :integer
#  date_effective      :date            default(Sat, 03 Dec 2011)
#  date_effective_end  :datetime
#

class Company < ActiveRecord::Base
  belongs_to :party
  has_one :operating_party
  has_many :accounts

  attr_accessible :name, :operating_party_attributes, :registration_number, :orig_id, :party_id, :date_effective, :date_effective_end
  accepts_nested_attributes_for :operating_party

  validates :name, :presence => true
  validate :registration_number_unique

  before_validation :trim_strings
  after_create :set_orig_id

  def default_account
    return accounts.where(:default_account => true).first
  end

  def invoice_address
    return party.addresses.where(:address_type_id => AddressType.find_by_name('BILL_TO').id).first || Address.new
  end

  def inv_address
    return party.addresses.where(:address_type_id => AddressType.find_by_name('BILL_TO').id).first
  end

  private

  def trim_strings
    self.registration_number = " #{self.registration_number} ".strip
    if self.registration_number.empty?
      self.registration_number = nil
    end
  end

  def set_orig_id
    if self.orig_id.nil?
      update_attribute(:orig_id, self.id)
    end
  end

  def registration_number_unique
    if persisted?
      if !Company.where("orig_id != ? and registration_number = ? and date_effective_end is null", orig_id, registration_number).first.nil?
        errors.add :registration_number, "should be unique!"
      end
    else
      if !Company.where("registration_number = ? and date_effective_end is null", registration_number).first.nil?
        errors.add :registration_number, "should be unique!"
      end
    end
  end

end
