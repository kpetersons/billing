# == Schema Information
#
# Table name: invoice_matters
#
#  id             :integer         not null, primary key
#  invoice_id     :integer
#  matter_id      :integer
#  matter_task_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe InvoiceMatter do
  pending "add some examples to (or delete) #{__FILE__}"
end
