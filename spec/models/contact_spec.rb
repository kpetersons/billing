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

require 'spec_helper'

describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end
