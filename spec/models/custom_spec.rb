# == Schema Information
#
# Table name: customs
#
#  id                    :integer(4)      not null, primary key
#  created_at            :datetime
#  updated_at            :datetime
#  matter_id             :integer(4)
#  date_of_order_alert   :date
#  ca_application_date   :date
#  ca_application_number :string(255)
#  client_all_ip         :integer(4)
#

require 'spec_helper'

describe Custom do
  pending "add some examples to (or delete) #{__FILE__}"
end
