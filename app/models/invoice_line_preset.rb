# == Schema Information
# Schema version: 20110704213116
#
# Table name: invoice_line_presets
#
#  id                   :integer(4)      not null, primary key
#  operating_party_id   :integer(4)
#  official_fee_type_id :integer(4)
#  attorney_fee_type_id :integer(4)
#  name                 :string(255)
#  official_fee         :string(255)
#  attorney_fee         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class InvoiceLinePreset < ActiveRecord::Base
  
  belongs_to :operating_party
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type

  validates :operating_party_id, :presence => true  

  def operating_party_name
    operating_party.name unless operating_party.nil? 
  end

  def official_fee_name
    official_fee_type.name unless official_fee_type.nil? 
  end

  def attorney_fee_name
    attorney_fee_type.name unless attorney_fee_type.nil?
  end

end
