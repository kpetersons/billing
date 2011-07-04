# == Schema Information
# Schema version: 20110704185444
#
# Table name: official_fee_types
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class OfficialFeeType < ActiveRecord::Base
end
