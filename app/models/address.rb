class Address < ActiveRecord::Base
  belongs_to :address_type
  belongs_to :party
  belongs_to :country

  validates :country_id, :presence => true
  validates :city, :presence => true
  validates :street, :presence => true
  validates :date_effective, :date_not_far_future => true
  validates :date_effective_end, :date_not_far_future => true

  attr_accessor :address_type_name

  before_validation :original_no_longer_used

  def history
    Address.where(:orig_id => orig_id).where("date_effective_end is not null and date_effective < :g", {:g => date_effective})
  end

  def name
    [line_1, line_2, line_3, line_4, line_5].reject{|x| (x.nil? || x.eql?(""))}.join(', ')
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
    return I18n.t(country.name) unless country.nil?
    return Country.new.name
  end

  def to_local_s
    address_data = []
    address_data<<line_1
    address_data<<line_2
    address_data<<line_3
    address_data<<line_4
    address_data<<line_5
    return address_data.reject { |n| n.nil? }.join(', ')
  end

  def no_longer_used
    update_attribute(:date_effective_end, DateTime.current)
  end

  private
  def original_no_longer_used
    originals = Address.find_all_by_orig_id(orig_id)
    originals.each do |original|
      original.no_longer_used unless original.id == self.id
    end
  end

end


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
#  date_effective     :date            default(Tue, 25 Dec 2012)
#  date_effective_end :datetime
#  suspended          :boolean
#

