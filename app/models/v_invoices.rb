class VInvoices < ActiveRecord::Base

  def self.quick_search query, page
    paginate :per_page => 10, :page => page, :conditions => ['customer_name like :q or person like :q or address like :q or currency like :q or author like :q or status like :q or our_ref like :q or your_ref like :q or po_billing like :q or subject like :q or ending_details like :q', {:q => "%#{query}%", :gi => query}]
  end
end
