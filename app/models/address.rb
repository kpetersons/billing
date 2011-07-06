# == Schema Information
# Schema version: 20110615122529
#
# Table name: addresses
#
#  id              :integer(4)      not null, primary key
#  party_id        :integer(4)
#  address_type_id :integer(4)
#  country         :string(255)
#  city            :string(255)
#  street          :string(255)
#  house_number    :string(255)
#  room_number     :string(255)
#  post_code       :string(255)
#  po_box          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Address < ActiveRecord::Base
  belongs_to :address_type
  belongs_to :party
  
  validates :country, :presence => true
  validates :city, :presence => true
  validates :street, :presence => true

  def name
    "#{country}, #{city}, #{street}, #{house_number}, #{post_code}"    
  end
  
end
