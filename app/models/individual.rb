# == Schema Information
#
# Table name: individuals
#
#  id          :integer         not null, primary key
#  party_id    :integer
#  gender_id   :integer
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

  def contact_person_for= customer
    self.customer = customer
  end
  
  def contact_person_for
    self.customer
  end
  
  def name
    name = []
    name << first_name unless first_name.nil?
    name << last_name unless last_name.nil?
    return name.join(',')
  end
  
end
