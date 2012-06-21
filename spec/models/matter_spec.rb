# == Schema Information
#
# Table name: matters
#
#  id                 :integer         not null, primary key
#  document_id        :integer
#  comment            :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  applicant_id       :integer
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  ir_number          :string(255)
#  mark_name          :string(255)
#  appl_date          :date
#  appl_number        :string(255)
#  agent_id           :integer
#  author_id          :integer
#  matter_type_id     :integer
#  operating_party_id :integer
#  matter_status_id   :integer
#  version            :integer         default(1)
#  orig_id            :integer
#  date_effective     :date            default(Thu, 29 Dec 2011)
#  date_effective_end :datetime
#

require 'spec_helper'

describe Matter do
  pending "add some examples to (or delete) #{__FILE__}"
end
