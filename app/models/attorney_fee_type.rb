# == Schema Information
#
# Table name: attorney_fee_types
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  description        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  operating_party_id :integer
#  apply_vat          :boolean
#  apply_discount     :boolean
#

class AttorneyFeeType < ActiveRecord::Base
  belongs_to :operating_party

  validates :operating_party_id, :presence => true
  validates :name, :presence => true
end
