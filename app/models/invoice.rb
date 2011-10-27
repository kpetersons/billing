# == Schema Information
#
# Table name: invoices
#
#  id                :integer         not null, primary key
#  document_id       :integer
#  customer_id       :integer
#  address_id        :integer
#  individual_id     :integer
#  currency_id       :integer
#  exchange_rate_id  :integer
#  discount          :integer
#  our_ref           :string(255)
#  your_ref          :string(255)
#  your_date         :date
#  po_billing        :string(255)
#  finishing_details :string(255)
#  invoice_date      :date
#  created_at        :datetime
#  updated_at        :datetime
#  author_id         :integer
#  exchange_rate     :decimal(7, 4)
#  subject           :string(2000)
#  ending_details    :string(2000)
#  payment_term      :integer(2)
#  apply_vat         :boolean
#  invoice_status_id :integer
#  date_paid         :date
#  foreign_number    :integer
#  local_number      :integer
#  invoice_type      :integer
#

class Invoice < ActiveRecord::Base

  belongs_to :document
  belongs_to :customer
  belongs_to :address
  belongs_to :individual
  belongs_to :currency
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  belongs_to :invoice_status
  has_many   :invoice_lines
  has_many   :invoice_matters
  has_many   :matters, :through => :invoice_matters

  attr_accessible :invoice_type,
                  :document_id,
                  :customer_id,
                  :address_id,
                  :author_id,
                  :individual_id,
                  :currency_id,
                  :discount,
                  :our_ref,
                  :your_ref,
                  :po_billing,
                  :finishing_details,
                  :invoice_date,
                  :invoice_lines_attributes,
                  :invoice_matters_attributes                  
  accepts_nested_attributes_for  :invoice_lines, :invoice_matters
  attr_protected :preset_id, :customer_name
  attr_accessor :preset_id

  after_create :generate_registration_number
  
  validates :discount, :numericality => true
  validates :invoice_date, :presence => true
  validates :invoice_type, :presence => true  
  validates :customer_id, :presence => true
  validates :payment_term, :presence => true, :numericality => true
  validates :subject, :presence => true, :length              => {:within => 5..500}
  
  before_save :mark_as_paid

  #start column filter 
  def ind_registration_number
    return "#{invoice_date.strftime("%y")}/#{document.registration_number}" if invoice_type == 0
    return document.registration_number
  end

  def ind_customer_name
    customer.name unless customer.nil?
  end

  def ind_individual_name
    return individual.name unless individual.nil?
    return Individual.new.name
  end
  
  def ind_currency_name
    currency.name unless currency.nil?
  end  
  
  def ind_author_name
    author.individual.name unless author.nil?
  end
  
  def ind_invoice_status_name
    invoice_status.name unless invoice_status.nil?
  end
  
  def ind_our_ref
    our_ref
  end
  
  def ind_your_ref
    your_ref
  end
  
  def ind_invoice_date
    invoice_date.to_s(:show) unless invoice_date.nil?
  end
  
  def ind_payment_term
    payment_term
  end
  
  def ind_address_name
    address_name
  end
  
  def ind_discount
    discount
  end
  
  def ind_your_date
    your_date.to_s(:show) unless your_date.nil?
  end
  
  def ind_po_billing
    po_billing
  end
  
  def ind_ending_details
    ending_details
  end
  
  def ind_created_at
    created_at.to_s(:show) unless created_at.nil?
  end
  
  def ind_updated_at
    updated_at.to_s(:show) unless updated_at.nil?
  end
  
  def ind_exchange_rate
    exchange_rate
  end
  
  def ind_subject
    subject
  end
  
  def ind_apply_vat
    apply_vat
  end
  
  def ind_date_paid
    date_paid.to_s(:show) unless date_paid.nil?
  end
  
  #end column filter  
  
  def self.new_foreign_reg_number
    puts "Invoice.where(:invoice_type=> foreign).count #{Invoice.where(:invoice_type=> 1).count}"
    return Invoice.where(:invoice_type=> 1).count
  end
  
  def self.new_local_reg_number
    puts "Invoice.where(:invoice_type=> local).count #{Invoice.where(:invoice_type=> 0).count}"
    return Invoice.where(:invoice_type=> 0).count
  end  
  
  def chk_address
    return address unless address.nil?
    return Address.new
  end
  
  def number
    document.registration_number
  end

  def classes
    clazzs.collect {|clazz| clazz.code}.join(',')
  end

  def customer_name
    (customer.nil?)? '' : customer.name
  end

  def address_name
    address.name unless address.nil?
  end

  def preset_id
    @preset_id
  end

  def preset_id= preset_id
    @preset_id = preset_id
  end

  def customer_name
    (customer.nil?)? '' : customer.name
  end

  def customer_addresses
    return customer.addresses.collect { |tt| [tt.name, tt.id] } unless customer.nil?
    return {'' => ''}
  end

  def customer_contact_persons
    return customer.contact_persons.collect { |tt| [tt.name, tt.id] } unless customer.nil?
    return {'' => ''}
  end

  def sum_official_fees
    invoice_lines.sum('official_fee')
  end

  def sum_attorney_fees
    invoice_lines.sum('attorney_fee')
  end

  def sum_total_fees
    sum_official_fees + sum_attorney_fees
  end

  def sum_discount
    sum_attorney_fees - sum_attorney_fees * discount/100 
  end

  def after_discount
    @sum_total_fees = sum_official_fees + sum_attorney_fees-sum_attorney_fees/100*discount
  end
  
  def sum_vat
    (sum_total_fees + sum_official_fees) * 0.22 
  end  
  
  def sum_total
    (sum_total_fees + sum_official_fees) * 1.22 
  end

  def status_name
    invoice_status.name unless invoice_status.nil?
  end

  def available_statuses
    InvoiceStatus.where("id != ?", [invoice_status_id]).all
  end
  
  def amount_without_vat
    value = 0
    invoice_lines.each do |line|
      value = value + line.official_fee unless line.official_fee.nil?
    end
    return value
  end

  def amount_with_vat
    value = 0
    invoice_lines.each do |line|
      value = value + line.attorney_fee unless line.attorney_fee.nil?
    end
    return value    
  end  

  def amount_vat
    return amount_with_vat * 0.22
  end

  def total_amount_with_vat
    return amount_with_vat * 1.22    
  end

  def contact_person
    return individual unless individual.nil?
    return Individual.new
  end
  
  private
  def mark_as_paid
    puts "invoice_status.name: #{invoice_status.name} and invoice_status.name.eql?('invoice.status.paid') #{invoice_status.name.eql?('invoice.status.paid')}"
    if invoice_status.name.eql?('invoice.status.paid') && date_paid.nil?
      self.date_paid = Date.today
    end
  end 
  
  def generate_registration_number
    Document.transaction do
      puts "invoice_type: #{invoice_type} #{invoice_type.class}"
      if invoice_type == 1
        foreign_number = Invoice.new_foreign_reg_number
        document.update_attribute(:registration_number, foreign_number)
      else
        local_number = Invoice.new_local_reg_number
        document.update_attribute(:registration_number, local_number)
      end
    end
  end
end
