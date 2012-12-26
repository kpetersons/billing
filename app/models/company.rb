class Company < ActiveRecord::Base
  belongs_to :party
  has_one :operating_party
  has_many :accounts

  attr_accessible :name, :operating_party_attributes, :registration_number, :orig_id, :party_id, :date_effective, :date_effective_end
  accepts_nested_attributes_for :operating_party

  validates :name, :presence => true
  validates :date_effective, :date_not_far_future => true
  validates :date_effective_end, :date_not_far_future => true

  validate :registration_number_unique

  before_validation :trim_strings
  #before_validation :original_no_longer_used
  after_create :set_orig_id

  def default_account
    accounts.where(:default_account => true).first
  end

  def invoice_address
    party.addresses.where(:address_type_id => AddressType.find_by_name('BILL_TO').id).first || Address.new
  end

  def inv_address
    party.addresses.where(:address_type_id => AddressType.find_by_name('BILL_TO').id).first
  end

  def copy_accounts _accounts
    _accounts.each do |_account|
      copy_account _account
    end
  end

  def copy_account _account
    _new =_account.dup
    self.accounts<< _new
  end

  def deep_dup
    other = self.dup
    other.orig_id = self.id
    other.party_id = nil
    return other
  end

  def no_longer_used
    update_attribute(:date_effective_end, DateTime.current)
  end

  private

  def original_no_longer_used
    originals = Company.find_all_by_orig_id orig_id
    originals.each do |original|
      original.no_longer_used unless original.id == self.id
    end
  end

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
      unless Company.where("registration_number = ? and date_effective_end is null and id != ?", registration_number, id).first.nil?
        errors.add :registration_number, "should be unique!"
      end
    else
      unless Company.where("registration_number = ? and date_effective_end is null", registration_number).first.nil?
        errors.add :registration_number, "should be unique!"
      end
    end
  end

end

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
#  date_effective      :date            default(Tue, 25 Dec 2012)
#  date_effective_end  :datetime
#

