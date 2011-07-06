# == Schema Information
#
# Table name: invoice_matters
#
#  id             :integer(4)      not null, primary key
#  invoice_id     :integer(4)
#  matter_id      :integer(4)
#  matter_task_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe InvoiceMatter do
  pending "add some examples to (or delete) #{__FILE__}"
end
