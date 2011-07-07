# == Schema Information
#
# Table name: matters
#
#  id                 :integer(4)      not null, primary key
#  document_id        :integer(4)
#  comment            :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  applicant_id       :integer(4)
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  ir_number          :string(255)
#  mark_name          :string(255)
#  appl_date          :date
#  appl_number        :string(255)
#  agent_id           :integer(4)
#  author_id          :integer(4)
#  matter_type_id     :integer(4)
#  operating_party_id :integer(4)
#

require 'spec_helper'

describe Matter do
  pending "add some examples to (or delete) #{__FILE__}"
end
