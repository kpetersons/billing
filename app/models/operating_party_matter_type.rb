# == Schema Information
#
# Table name: operating_party_matter_types
#
#  id                 :integer         not null, primary key
#  operating_party_id :integer
#  matter_type_id     :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class OperatingPartyMatterType < ActiveRecord::Base
  belongs_to :operating_party
  belongs_to :matter_type  
  
  validates :operating_party_id, :presence => true
  validates :matter_type_id, :presence => true
end
