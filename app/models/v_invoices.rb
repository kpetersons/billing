class VInvoices < ActiveRecord::Base

  def self.quick_search query, page, per_page
    paginate :per_page => per_page, :page => page, :conditions => ['registration_number ilike :q or customer_name ilike :q or person ilike :q or address ilike :q or currency ilike :q or author ilike :q or status ilike :q or our_ref ilike :q or your_ref ilike :q or po_billing ilike :q or subject ilike :q or ending_details ilike :q', {:q => "%#{query}%", :gi => query}]
  end
end

# == Schema Information
#
# Table name: v_invoices
#
#  registration_number :text
#  operating_party_id  :integer
#  id                  :integer         primary key
#  author_id           :integer
#  customer_name       :string(255)
#  person              :text
#  address             :text
#  currency            :string(255)
#  author              :text
#  status              :string(255)
#  our_ref             :string(255)
#  your_ref            :string(255)
#  your_date           :date
#  invoice_date        :date
#  payment_term        :integer(2)
#  discount            :integer
#  po_billing          :string(255)
#  subject             :string(2000)
#  ending_details      :string(2000)
#  created_at          :datetime
#  updated_at          :datetime
#  rate                :decimal(8, 3)
#  apply_vat           :boolean
#  date_paid           :date
#  total_official_fee  :decimal(, )
#  total_vat           :decimal(, )
#  grand_total         :decimal(, )
#  total_attorney_fee  :decimal(, )
#  total_discount      :decimal(, )
#  matter_type_id      :integer
#  issued_by           :string(255)
#

