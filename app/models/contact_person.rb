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

class ContactPerson < ActiveRecord::Base
  
  set_table_name "individuals"
  
  belongs_to :party
  belongs_to :gender

  attr_accessible :first_name, :middle_name, :last_name, :gender_id, :birth_date, :user_attributes

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :birth_date, :presence => true
  validates :birth_date, :date_not_far_future => true

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
  
end
