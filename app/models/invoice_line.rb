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
#  official_fee         :decimal(8, 2)
#  attorney_fee         :decimal(8, 2)
#  author_id            :integer
#  offering             :text
#  items                :decimal(10, 2)
#  units                :string(255)
#  total                :decimal(10, 2)
#  total_attorney_fee   :decimal(10, 2)
#  total_official_fee   :decimal(10, 2)
#  total_discount       :decimal(10, 2)
#  billing_settings_id  :integer
#

class InvoiceLine < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :invoice
  belongs_to :official_fee_type
  belongs_to :attorney_fee_type
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  belongs_to :billing_setting

  validates :attorney_fee_type_id, :presence => true, :if => Proc.new { |invoice_line| !invoice_line.attorney_fee.nil? }
  validates :official_fee_type_id, :presence => true, :if => Proc.new { |invoice_line| !invoice_line.official_fee.nil? }
  #
  validates :offering, :presence => true, :length => {:within => 5..1000}
  validates :details,  :length => {:maximum => 1000}
  validates :items, :presence => true, :numericality => true

  before_save :calculate_totals
  before_create :set_vat_rate
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

    attorney_fee_print = (attorney_fee.to_i == attorney_fee)? number_with_precision(attorney_fee, :precision => 0) :  number_with_precision(attorney_fee, :precision => 2, :separator => ".")
    items_print        = (items.to_i ==        items)       ? number_with_precision(items,        :precision => 0) : number_with_precision(items,        :precision => 2, :separator => ".")

    brackets_tmp = (items.nil?)? "" : " (#{items_print} #{units} x #{invoice.currency.name} #{attorney_fee_print})"
    details_tmp = "#{details}#{brackets_tmp}"

    return (both_official_and_attorney?)? details : details_tmp
  end

  def offering_print
    items_print = (items.to_i == items)? number_with_precision(items, :precision => 0) : items
    return (both_official_and_attorney?)? "#{offering} x#{items_print.to_s}" : offering
  end

  private

  def calculate_totals
    if invoice
      self.total_attorney_fee= (((attorney_fee.nil?) ? 0 : attorney_fee) * ((items.nil?) ? 0 : items))
      self.total_official_fee= (((official_fee.nil?) ? 0 : official_fee) * ((items.nil?) ? 0 : items))
      if !self.attorney_fee_type_id.nil? && AttorneyFeeType.find(self.attorney_fee_type_id).apply_discount?
        self.total_discount= (total_attorney_fee * ((invoice.discount.nil?) ? 0 : invoice.discount) / 100)
      else
        self.total_discount= 0
      end
      self.total= (total_attorney_fee + total_official_fee - total_discount)
    end
  end

  def set_vat_rate
    self.billing_settings_id = invoice.billing_settings_id
  end

end
