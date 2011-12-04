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

require 'spec_helper'

describe Address do
  pending "add some examples to (or delete) #{__FILE__}"
end
