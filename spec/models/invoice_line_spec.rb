require 'spec_helper'

describe InvoiceLine do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: invoice_lines
#
#  id                   :integer         not null, primary key
#  invoice_id           :integer
#  official_fee_type_id :integer
#  details              :text
#  created_at           :datetime
#  updated_at           :datetime
#  attorney_fee_type_id :integer
#  offering             :text
#  official_fee         :decimal(8, 2)
#  attorney_fee         :decimal(8, 2)
#  author_id            :integer
#  items                :decimal(10, 2)
#  units                :string(255)
#  total                :decimal(10, 2)
#  total_attorney_fee   :decimal(10, 2)
#  total_official_fee   :decimal(10, 2)
#  total_discount       :decimal(10, 2)
#  billing_settings_id  :integer
#

