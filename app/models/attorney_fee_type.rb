# == Schema Information
#
# Table name: attorney_fee_types
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  description        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  operating_party_id :integer(4)
#

class AttorneyFeeType < ActiveRecord::Base
  belongs_to :operating_party

  validates :operating_party_id, :presence => true
end
