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

  def self.all_available current_user
    if current_user.has_function :name => "funct.view.all.fee.types"
      return OfficialFeeType.all
    else
      return OfficialFeeType.where(:operating_party_id => current_user.operating_party_id).all
    end
  end
end
