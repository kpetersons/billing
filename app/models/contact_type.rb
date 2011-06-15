# == Schema Information
# Schema version: 20110615122529
#
# Table name: contact_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  built_in   :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class ContactType < ActiveRecord::Base
  has_many :contacts
end
