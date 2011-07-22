# == Schema Information
#
# Table name: invoice_lines
#
#  id                   :integer(4)      not null, primary key
#  invoice_id           :integer(4)
#  official_fee_type_id :integer(4)
#  details              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  attorney_fee_type_id :integer(4)
#  official_fee         :decimal(8, 2)
#  attorney_fee         :decimal(8, 2)
#  author_id            :integer(4)
#  offering             :string(255)
#  items                :integer(4)
#  units                :string(255)
#

require 'spec_helper'

describe InvoiceLine do
  pending "add some examples to (or delete) #{__FILE__}"
end
