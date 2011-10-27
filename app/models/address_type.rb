# == Schema Information
#
# Table name: address_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  built_in   :boolean
#  created_at :datetime
#  updated_at :datetime
#  party_id   :integer
#

class AddressType < ActiveRecord::Base
  belongs_to :party
  
  def self.for_party party
    where("party_id = :party or built_in = :built_in", {:party => party[:party].id, :built_in => true}).all
  end
  
end
