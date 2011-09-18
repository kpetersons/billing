# == Schema Information
#
# Table name: accounts
#
#  id              :integer(4)      not null, primary key
#  bank            :string(255)
#  bank_code       :string(255)
#  account_number  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  company_id      :integer(4)
#  default_account :boolean(1)
#  show_on_invoice :boolean(1)
#

class Account < ActiveRecord::Base  
  belongs_to :company
  
  
end
