# == Schema Information
#
# Table name: official_fee_types
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  description        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  operating_party_id :integer(4)
#

class OfficialFeeType < ActiveRecord::Base
  belongs_to :operating_party
end
