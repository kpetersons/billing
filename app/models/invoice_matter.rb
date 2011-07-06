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

class InvoiceMatter < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :matter_task  
  belongs_to :invoice   
  
end
