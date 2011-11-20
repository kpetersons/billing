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
#  items                :decimal(10, 2)
#  units                :string(255)
#  total                :decimal(10, 2)
#  total_attorney_fee   :decimal(10, 2)
#  total_official_fee   :decimal(10, 2)
#  total_discount       :decimal(10, 2)
#

class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type
  belongs_to :author, :class_name => "User", :foreign_key => :author_id

  validates :attorney_fee_type_id, :presence => true, :if => Proc.new { |invoice_line| !invoice_line.attorney_fee.nil? }
  validates :official_fee_type_id, :presence => true, :if => Proc.new { |invoice_line| !invoice_line.official_fee.nil? }
  #
  validates :offering, :presence => true, :length => {:within => 5..250}
  validates :items, :presence => true, :numericality => true

  before_save :calculate_totals

  validate :local_fees_exclusion

  def local_fees_exclusion
    if invoice.invoice_type == 0 &&
        (
          (!official_fee.nil? && !attorney_fee.nil?) ||
          (!official_fee_type_id.nil? && !attorney_fee_type_id.nil?)
        )
      errors.add(:official_fee_type_id, "Local invoices may no have Official fee AND Attorney's fee on the same line ")
    end
    return false
  end

  def is_official
    !official_fee_type_id.nil?
  end

  def both_official_and_attorney?
    !official_fee_type_id.nil? && !attorney_fee_type_id.nil?
  end

  def line_details
    attorney_fee_print = attorney_fee.to_s.gsub('.00', '').gsub('.0', '')
    brackets_tmp = (items.nil?)? "" : " (#{items} #{units} x #{invoice.currency.name} #{attorney_fee_print})"
    details_tmp = "#{details}#{brackets_tmp}"
    return (both_official_and_attorney?)? "#{details} x#{items}" : details_tmp
  end

  private

  def calculate_totals
    self.total_attorney_fee= (((attorney_fee.nil?) ? 0 : attorney_fee) * ((items.nil?) ? 0 : items))
    self.total_official_fee= (((official_fee.nil?) ? 0 : official_fee) * ((items.nil?) ? 0 : items))
    if !self.attorney_fee_type_id.nil? && AttorneyFeeType.find(self.attorney_fee_type_id).apply_discount?
      self.total_discount= (total_attorney_fee * ((invoice.discount.nil?) ? 0 : invoice.discount) / 100)
    else
      self.total_discount= 0
    end
    self.total= (total_attorney_fee + total_official_fee - total_discount)
    puts ""
  end


end
