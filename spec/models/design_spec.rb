# == Schema Information
#
# Table name: designs
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer(4)
#  application_number :string(255)
#  application_date   :date
#  design_number      :string(255)
#  rdc_appl_number    :string(255)
#  rdc_number         :string(255)
#

require 'spec_helper'

describe Design do
  pending "add some examples to (or delete) #{__FILE__}"
end
