# == Schema Information
#
# Table name: contacts
#
#  id              :integer         not null, primary key
#  party_id        :integer
#  contact_type_id :integer
#  contact_value   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Contact < ActiveRecord::Base
  
  belongs_to :contact_type
  belongs_to :party
  
  validates :contact_value, :presence => true
  
end
