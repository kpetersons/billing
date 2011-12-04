# == Schema Information
#
# Table name: v_invoices
#
#  operating_party_id :integer
#  id                 :integer         primary key
#  author_id          :integer
#  customer_name      :string(255)
#  person             :text
#  address            :text
#  currency           :string(255)
#  author             :text
#  status             :string(255)
#  our_ref            :string(255)
#  your_ref           :string(255)
#  your_date          :date
#  invoice_date       :date
#  payment_term       :integer(2)
#  discount           :integer
#  po_billing         :string(255)
#  subject            :string(2000)
#  ending_details     :string(2000)
#  created_at         :datetime
#  updated_at         :datetime
#  rate               :decimal(8, 3)
#  apply_vat          :boolean
#  date_paid          :date
#

class VInvoices < ActiveRecord::Base

  def self.quick_search query, page
    paginate :per_page => 10, :page => page, :conditions => ['customer_name like :q or person like :q or address like :q or currency like :q or author like :q or status like :q or our_ref like :q or your_ref like :q or po_billing like :q or subject like :q or ending_details like :q', {:q => "%#{query}%", :gi => query}]
  end
end
