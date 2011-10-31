# == Schema Information
#
# Table name: invoice_lines
#
#  id                   :integer         not null, primary key
#  invoice_id           :integer
#  official_fee_type_id :integer
#  details              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  attorney_fee_type_id :integer
#  official_fee         :decimal(8, 2)
#  attorney_fee         :decimal(8, 2)
#  author_id            :integer
#  offering             :string(255)
#  items                :integer
#  units                :string(255)
#

class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type
  belongs_to :author, :class_name => "User", :foreign_key => :author_id

  validates :attorney_fee_type_id, :presence => true, :if => Proc.new { |invoice_line| !invoice_line.attorney_fee.nil? }
  validates :official_fee_type_id, :presence => true, :if => Proc.new { |invoice_line| !invoice_line.official_fee.nil? }
  validates :offering, :presence => true, :length => {:within => 5..250}
  validates :items, :presence => true, :numericality => true

  before_save :calculate_totals

  def is_official
    if !official_fee_type_id.nil?
      return true
    end
    return false
  end

  private

  def calculate_totals
    #update_attribute(:total_attorney_fee, (((attorney_fee.nil?) ? 0 : attorney_fee) * ((items.nil?) ? 0 : items)))
    #update_attribute(:total_official_fee, (((official_fee.nil?) ? 0 : official_fee) * ((items.nil?) ? 0 : items)))
    #update_attribute(:total_discount, (total_attorney_fee * ((invoice.discount.nil?) ? 0 : invoice.discount) / 100))
    #update_attribute(:total, (total_attorney_fee + total_official_fee - total_discount))
    #
    self.total_attorney_fee= (((attorney_fee.nil?) ? 0 : attorney_fee) * ((items.nil?) ? 0 : items))
    self.total_official_fee= (((official_fee.nil?) ? 0 : official_fee) * ((items.nil?) ? 0 : items))
    self.total_discount= (total_attorney_fee * ((invoice.discount.nil?) ? 0 : invoice.discount) / 100)
    self.total= (total_attorney_fee + total_official_fee - total_discount)
    puts "invoice_discount.nil? no? #{invoice.discount}"
  end

end
