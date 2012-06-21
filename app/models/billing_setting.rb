# == Schema Information
#
# Table name: billing_settings
#
#  id               :integer         not null, primary key
#  vat_rate         :decimal(8, 2)
#  active           :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  activated_when   :date
#  deactivated_when :date
#

class BillingSetting < ActiveRecord::Base

  has_many :invoices
  has_many :invoice_lines

  before_create :invalidate_old
  after_create :activate_self

  def invalidate_old
    BillingSetting.all.each do |item|
      item.update_attribute(:active, false)
      item.update_attribute(:deactivated_when, DateTime.now)
    end
  end

  def activate_self
    self.update_attribute(:active, true)
    self.update_attribute(:activated_when, DateTime.now)
  end

end
