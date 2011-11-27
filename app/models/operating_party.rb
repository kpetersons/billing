# == Schema Information
#
# Table name: operating_parties
#
#  id                 :integer         not null, primary key
#  company_id         :integer
#  operating_party_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class OperatingParty < ActiveRecord::Base

  belongs_to :company;
  belongs_to :parent_operating_party, :class_name => "OperatingParty", :foreign_key => "operating_party_id"
  has_many :operating_parties, :class_name => "OperatingParty", :foreign_key => "operating_party_id"
  has_many :users, :foreign_key => "operating_party_id"
  has_many :operating_party_matter_types
  has_many :matter_types, :through => :operating_party_matter_types
  has_many :matters
  has_many :official_fee_types
  has_many :attorney_fee_types

  def party
    company.party
  end

  def name
    company.name
  end

  def parent_name
    parent_operating_party.company.name unless parent_operating_party.nil?
  end

  def registration_number
    company.registration_number
  end

  def default_account
    return company.default_account unless company.default_account.nil?
    return Account.new
  end

  def invoice_address
    return company.invoice_address
  end

  def own_and_child_ids
    ids = []<<id
    ids = children self, ids
  end

  private
  def children parent, list
    OperatingParty.find_all_by_operating_party_id(parent.id).each do |x|
      list << x.id
      children x, list
    end
    return list
  end

end
