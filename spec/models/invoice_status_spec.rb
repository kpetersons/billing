# == Schema Information
#
# Table name: invoice_statuses
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  revert_to_name :string(255)
#  pass_to_name   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe InvoiceStatus do
  pending "add some examples to (or delete) #{__FILE__}"
end
