# == Schema Information
# Schema version: 20110704211205
#
# Table name: attorney_fee_types
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class AttorneyFeeType < ActiveRecord::Base
end
