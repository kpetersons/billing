# == Schema Information
#
# Table name: legals
#
#  id                      :integer         not null, primary key
#  created_at              :datetime
#  updated_at              :datetime
#  matter_id               :integer
#  opposed_marks           :string(255)
#  instance                :string(255)
#  date_of_closure         :date
#  opposite_party_id       :integer
#  opposite_party_agent_id :integer
#  legal_type_id           :integer
#  date_of_order           :date
#  court_ref               :text
#

require 'spec_helper'

describe Legal do
  pending "add some examples to (or delete) #{__FILE__}"
end
