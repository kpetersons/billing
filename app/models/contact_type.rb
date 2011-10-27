# == Schema Information
#
# Table name: contact_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  built_in   :boolean
#  created_at :datetime
#  updated_at :datetime
#

class ContactType < ActiveRecord::Base
  has_many :contacts
end
