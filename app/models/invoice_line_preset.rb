# == Schema Information
#
# Table name: invoice_line_presets
#
#  id                   :integer         not null, primary key
#  operating_party_id   :integer
#  official_fee_type_id :integer
#  attorney_fee_type_id :integer
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  author_id            :integer
#  private_preset       :boolean
#  official_fee         :decimal(8, 2)
#  attorney_fee         :decimal(8, 2)
#

class InvoiceLinePreset < ActiveRecord::Base
  
  belongs_to :operating_party
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type
  belongs_to :author, :class_name => 'User', :foreign_key => :author_id

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

  def official_fee
    super
  end

  def attorney_fee
    super
  end

end
