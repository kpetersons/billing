# == Schema Information
#
# Table name: domains
#
#  id                :integer         not null, primary key
#  matter_id         :integer
#  domain_name       :string(255)
#  registration_date :date
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Domain do
  pending "add some examples to (or delete) #{__FILE__}"
end
