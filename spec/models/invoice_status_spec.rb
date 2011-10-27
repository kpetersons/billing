# == Schema Information
#
# Table name: invoice_statuses
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  function_id    :integer
#  editable_state :boolean
#

require 'spec_helper'

describe InvoiceStatus do
  pending "add some examples to (or delete) #{__FILE__}"
end
