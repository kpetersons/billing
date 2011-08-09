# == Schema Information
#
# Table name: invoices
#
#  id                :integer(4)      not null, primary key
#  document_id       :integer(4)
#  customer_id       :integer(4)
#  address_id        :integer(4)
#  individual_id     :integer(4)
#  currency_id       :integer(4)
#  exchange_rate_id  :integer(4)
#  discount          :integer(4)
#  our_ref           :string(255)
#  your_ref          :string(255)
#  your_date         :date
#  po_billing        :string(255)
#  finishing_details :string(255)
#  invoice_date      :date
#  created_at        :datetime
#  updated_at        :datetime
#  author_id         :integer(4)
#  exchange_rate     :decimal(7, 4)
#  subject           :string(2000)
#  ending_details    :string(2000)
#  payment_term      :integer(1)
#  apply_vat         :boolean(1)
#  invoice_status_id :integer(4)
#  date_paid         :date
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

  attr_accessible :document_id,
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
  validates :customer_id, :presence => true
  validates :payment_term, :presence => true, :numericality => true
  validates :subject, :presence => true, :length              => {:within => 5..250}
  
  before_save :mark_as_paid
  
  
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
    address.name
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

  def after_discount
    @sum_total_fees = sum_official_fees + sum_attorney_fees-sum_attorney_fees/100*discount
  end
  
  def sum_vat
    (sum_total_fees + sum_official_fees) * 0.22 
  end  
  
  def sum_total
    (sum_total_fees + sum_official_fees) * 1.22 
  end

  def generate_registration_number
    Document.transaction do
      @reg_nr = "#{id}"
      document.update_attribute(:registration_number, @reg_nr)
    end
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
  
end
