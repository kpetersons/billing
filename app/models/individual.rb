# == Schema Information
# Schema version: 20110609074500
#
# Table name: individuals
#
#  id          :integer(4)      not null, primary key
#  party_id    :integer(4)
#  gender_id   :integer(4)
#  first_name  :string(255)
#  middle_name :string(255)
#  last_name   :string(255)
#  birth_date  :date
#  created_at  :datetime
#  updated_at  :datetime
#

class Individual < ActiveRecord::Base
  
  belongs_to :party
  belongs_to :gender
  has_one :user

  attr_accessible :first_name, :middle_name, :last_name, :gender_id, :birth_date, :user_attributes
  accepts_nested_attributes_for :user

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :birth_date, :presence => true

  def gender_name
    unless gender.nil?
      gender.name
    end
    ''
  end

  def is_contact
    party.source_parties( :relationship_type => RelationshipType.find_by_name('CONTACT_PERSON')).first
  end
  
end
