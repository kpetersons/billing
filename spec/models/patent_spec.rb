# == Schema Information
#
# Table name: patents
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer(4)
#  application_number :string(255)
#  application_date   :date
#  patent_number      :string(255)
#  patent_grant_date  :date
#  ep_appl_number     :string(255)
#  ep_number          :string(255)
#

require 'spec_helper'

describe Patent do
  pending "add some examples to (or delete) #{__FILE__}"
end
