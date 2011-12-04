# == Schema Information
#
# Table name: patents
#
#  id                 :integer         not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  application_number :string(255)
#  application_date   :date
#  patent_number      :string(255)
#  patent_grant_date  :date
#  ep_appl_number     :string(255)
#  ep_number          :integer
#  registration_date  :date
#

require 'spec_helper'

describe Patent do
  pending "add some examples to (or delete) #{__FILE__}"
end
