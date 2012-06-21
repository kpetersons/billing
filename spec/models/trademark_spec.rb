# == Schema Information
#
# Table name: trademarks
#
#  id                 :integer         not null, primary key
#  appl_date          :date
#  appl_number        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  mark_name          :string(255)
#  cfe_index          :string(255)
#  application_date   :date
#  application_number :string(255)
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  reg_number         :string(255)
#  registration_date  :date
#

require 'spec_helper'

describe Trademark do
  pending "add some examples to (or delete) #{__FILE__}"
end
