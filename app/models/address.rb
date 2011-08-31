# == Schema Information
#
# Table name: addresses
#
#  id              :integer(4)      not null, primary key
#  party_id        :integer(4)
#  address_type_id :integer(4)
#  city            :string(255)
#  street          :string(255)
#  house_number    :string(255)
#  room_number     :string(255)
#  post_code       :string(255)
#  po_box          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  country_id      :integer(4)
#

class Address < ActiveRecord::Base
  belongs_to :address_type
  belongs_to :party
  belongs_to :country
  
  validates :country_id, :presence => true
  validates :city, :presence => true
  validates :street, :presence => true

  attr_accessor :address_type_name

  def name
    "#{city}, #{street}, #{house_number}, #{post_code}, #{country.name}"    
  end
  
  def line_1
    return city unless city.nil? || city.empty?
    return nil
  end
  
  def line_2
    return street unless street.nil? || street.empty?
    return nil
  end
  
  def line_3
    return house_number unless house_number.nil? || house_number.empty?
    return nil
  end
  
  def line_4
    return room_number unless room_number.nil? || room_number.empty?
    return nil
  end
  
  def line_5
    return country.name unless country.nil?
    return Country.new
  end
  
end
