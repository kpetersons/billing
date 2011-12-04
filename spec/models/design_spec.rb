# == Schema Information
#
# Table name: designs
#
#  id                 :integer         not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  application_number :string(255)
#  application_date   :date
#  design_number      :string(255)
#  rdc_appl_number    :string(255)
#  rdc_number         :string(255)
#  registration_date  :date
#

require 'spec_helper'

describe Design do
  pending "add some examples to (or delete) #{__FILE__}"
end
