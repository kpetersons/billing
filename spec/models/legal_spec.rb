# == Schema Information
#
# Table name: legals
#
#  id                      :integer(4)      not null, primary key
#  created_at              :datetime
#  updated_at              :datetime
#  matter_id               :integer(4)
#  opposed_marks           :string(255)
#  instance                :string(255)
#  date_of_closure         :date
#  oposing_party_id        :integer(4)
#  oposing_party_agent_id  :integer(4)
#  opposite_party_id       :integer(4)
#  opposite_party_agent_id :integer(4)
#  legal_type_id           :integer(4)
#

require 'spec_helper'

describe Legal do
  pending "add some examples to (or delete) #{__FILE__}"
end
