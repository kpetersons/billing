# == Schema Information
#
# Table name: official_fee_types
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

class OfficialFeeType < ActiveRecord::Base
  
  belongs_to :operating_party
  has_many :invoice_lines
  
  validates :operating_party_id, :presence => true
  validates :name, :presence => true
end
