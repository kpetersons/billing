# == Schema Information
#
# Table name: addresses
#
#  id                 :integer         not null, primary key
#  party_id           :integer
#  address_type_id    :integer
#  city               :string(255)
#  street             :string(255)
#  house_number       :string(255)
#  room_number        :string(255)
#  post_code          :string(255)
#  po_box             :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  country_id         :integer
#  version            :integer         default(1)
#  orig_id            :integer
#  date_effective     :date            default(Sat, 03 Dec 2011)
#  date_effective_end :datetime
#

class Address < ActiveRecord::Base
  belongs_to :address_type
  belongs_to :party
  belongs_to :country

  validates :country_id, :presence => true
  validates :city, :presence => true
  validates :street, :presence => true

  attr_accessor :address_type_name

  def history
    Address.where(:orig_id => orig_id).where("date_effective_end is not null and date_effective < :g", {:g => date_effective})
  end

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
    return Country.new.name
  end

  def to_local_s
    address_data = []
    address_data<<line_1
    address_data<<line_2
    address_data<<line_3
    address_data<<line_4
    address_data<<line_5
    puts "address array:                    #{address_data}"
    return address_data.reject { |n| n.nil? }.join(', ')
  end

end
