# == Schema Information
#
# Table name: matter_customers
#
#  id            :integer         not null, primary key
#  matter_id     :integer
#  customer_id   :integer
#  takeover_date :date
#  shortnote     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  author_id     :integer
#  customer_type :string(255)
#

require 'spec_helper'

describe MatterCustomer do
  pending "add some examples to (or delete) #{__FILE__}"
end
