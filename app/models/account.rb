# == Schema Information
#
# Table name: accounts
#
#  id              :integer         not null, primary key
#  bank            :string(255)
#  bank_code       :string(255)
#  account_number  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  company_id      :integer
#  default_account :boolean
#  show_on_invoice :boolean
#

class Account < ActiveRecord::Base
  belongs_to :company

  before_validation :original_no_longer_used

  def no_longer_used
    update_attribute(:date_effective_end, DateTime.current)
  end

  private
  def original_no_longer_used
    originals = Account.find_all_by_orig_id orig_id
    originals.each do |original|
      original.no_longer_used unless original.id == self.id
    end
  end

end
