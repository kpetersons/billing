# == Schema Information
# Schema version: 20110615122529
#
# Table name: contacts
#
#  id              :integer(4)      not null, primary key
#  party_id        :integer(4)
#  contact_type_id :integer(4)
#  contact_value   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Contact < ActiveRecord::Base
  
  belongs_to :contact_type
  belongs_to :party
  
  validates :contact_value, :presence => true
  
end
