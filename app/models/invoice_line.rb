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
#

class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type
  belongs_to  :author, :class_name => "User", :foreign_key => :author_id  
end
