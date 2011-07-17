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

require 'spec_helper'

describe Address do
  pending "add some examples to (or delete) #{__FILE__}"
end
