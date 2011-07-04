# == Schema Information
# Schema version: 20110704185444
#
# Table name: invoice_lines
#
#  id                   :integer(4)      not null, primary key
#  invoice_id           :integer(4)
#  official_fee_type_id :integer(4)
#  off_fee              :string(255)
#  attorneys_fee        :string(255)
#  details              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class InvoiceLine < ActiveRecord::Base
end
