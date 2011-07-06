# == Schema Information
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

require 'spec_helper'

describe Contact do
  pending "add some examples to (or delete) #{__FILE__}"
end
