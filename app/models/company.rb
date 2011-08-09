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
  has_many :accounts

  attr_accessible :party_id, :name, :operating_party_attributes, :registration_number
  accepts_nested_attributes_for :operating_party

  validates :name, :presence => true
  validates :registration_number, :uniqueness => true, :allow_nil => true

  before_validation :trim_strings
  
  def default_account
    return accounts.where(:default_account => true).first
  end

  def invoice_address
    addr = party.addresses.where(:address_type_id => AddressType.find_by_name('BILL_TO').id).first
    unless addr.nil?
       return "#{addr.city}, #{addr.street}, #{addr.house_number}, #{addr.room_number}"
    end 
    return Address.new
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

end
