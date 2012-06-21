# == Schema Information
#
# Table name: invoices
#
#  id                  :integer         not null, primary key
#  document_id         :integer
#  customer_id         :integer
#  address_id          :integer
#  individual_id       :integer
#  currency_id         :integer
#  exchange_rate_id    :integer
#  discount            :integer
#  our_ref             :string(255)
#  your_ref            :string(255)
#  your_date           :date
#  po_billing          :string(255)
#  finishing_details   :string(255)
#  invoice_date        :date
#  created_at          :datetime
#  updated_at          :datetime
#  author_id           :integer
#  exchange_rate       :decimal(7, 4)
#  subject             :string(2000)
#  ending_details      :string(2000)
#  payment_term        :integer(2)
#  apply_vat           :boolean
#  invoice_status_id   :integer
#  date_paid           :date
#  foreign_number      :integer
#  local_number        :integer
#  invoice_type        :integer
#  matter_type_id      :integer
#  author_name         :string(255)
#  billing_settings_id :integer
#

class Invoice < ActiveRecord::Base

  belongs_to :document
  belongs_to :customer
  belongs_to :address
  belongs_to :individual
  belongs_to :currency
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  belongs_to :invoice_status
  belongs_to :billing_setting

  has_many :invoice_lines, :order => :id
  has_many :invoice_matters
  has_many :matters, :through => :invoice_matters

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

  accepts_nested_attributes_for :invoice_lines, :invoice_matters
  attr_protected :preset_id, :customer_name
  attr_accessor :preset_id

  after_create :generate_registration_number

  validates :discount, :numericality => true
  validates :invoice_date, :presence => true
  validates :invoice_type, :presence => true
  validates :customer_id, :presence => true
  validates :payment_term, :presence => true, :numericality => true
  validates :subject, :presence => true, :length => {:within => 5..1999}
  validates :author_name, :presence => true

  validates :your_date, :date_not_far_future => true
  validates :date_paid, :date_not_far_future => true
  validates :invoice_date, :date_not_far_future => true

  validate :if_paid_then_when
  validate :not_future
  validate :our_ref_present

  before_validation :parse_our_refs
  before_save :mark_as_paid
  before_save :set_matter_type
  before_create :set_vat_rate
  #
  after_update :update_lines

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
    return author.individual.name unless author.nil?
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
    return Invoice.where(:invoice_type=> 1).count + 26268
  end

  def self.new_local_reg_number
    return Invoice.where(:invoice_type=> 0).where("to_char(invoice_date, 'YYYY') = to_char(now(), 'YYYY')").count
  end

  def chk_address
    return address unless address.nil?
    return Address.new
  end

  def number
    document.registration_number
  end

  def classes
    clazzs.collect { |clazz| clazz.code }.join(',')
  end

  def customer_name
    (customer.nil?) ? '' : customer.name
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
    (customer.nil?) ? '' : customer.name
  end

  def customer_addresses
    return customer.addresses.collect { |tt| [tt.name, tt.id] } unless customer.nil?
    return {'' => ''}
  end

  def customer_contact_persons
    return customer.contact_persons.collect { |tt| [tt.name, tt.id] } unless customer.nil?
    return {'' => ''}
  end

  #start foreign invoice print

  def sum_attorney_fees
    (invoice_lines.sum(:total_attorney_fee)).round(2)
  end

  def sum_official_fees
    invoice_lines.sum(:total_official_fee)
  end

  def sum_discount
    invoice_lines.sum(:total_discount)
  end

  def sum_vat
    if apply_vat?
      ((sum_attorney_fees - sum_discount + sum_official_fees) * billing_setting.vat_rate).round(2)
    end
  end

  def sum_total
    if apply_vat
      return sum_attorney_fees - sum_discount + sum_official_fees + sum_vat
    end
    return sum_attorney_fees - sum_discount + sum_official_fees
  end

  #end foreign invoice print

  #start local invoice print
  def local_sum_exempt_vat
    invoice_lines.joins(:official_fee_type).where(:official_fee_types => {:apply_vat => false}).sum('total_official_fee')
  end

  def local_sum_taxable_vat
    official_taxable = invoice_lines.joins(:official_fee_type).where(:official_fee_types => {:apply_vat => true}).sum('total_official_fee')
    attorney_taxable = invoice_lines.sum('total_attorney_fee')
    return official_taxable + attorney_taxable
  end

  def local_sum_vat
    local_sum_taxable_vat * BillingSetting.find(billing_settings_id).vat_rate
  end

  def local_sum_total
    local_sum_exempt_vat + local_sum_taxable_vat + local_sum_vat
  end

  #end local invoice print

  def status_name
    invoice_status.name unless invoice_status.nil?
  end

  def available_statuses
    InvoiceStatus.where("id != ?", [invoice_status_id]).all
  end

  def contact_person
    return individual unless individual.nil?
    return Individual.new
  end

  def has_lines?
    return !invoice_lines.empty?
  end

  def self.quick_search query, page, per_page
    joins(:customer => [:party => [:company]]).paginate :per_page => per_page, :page => page,
                                                        :conditions => ['our_ref ilike :q or companies.name ilike :q or your_ref ilike :q',
                                                                        {:q => "%#{query}%", :gi => query}]
  end

  def our_ref_matters
    @our_ref_matters
  end

  def local_our_ref
    "#{author.initials}/#{our_ref}"
  end


  def has_official_fees?
    !invoice_lines.where("official_fee_type_id is not null").all.empty?
  end

  private

  def if_paid_then_when
    status_test = status_name.eql? "invoice.status.paid"
    if status_test && (self.date_paid.nil?)
      errors.add(:date_paid, "should be entered before marking invoice as paid.")
    end
  end

  def parse_our_refs
    @our_refs = []
    @our_refs_invalid = []
    our_ref.split(/;/).each do |item|
      items = item.split('-')
      if items.length < 2
        @our_refs << item
      else
        str_prefix = items[0].gsub(/[0-9]/, '')
        str_start = items[0].gsub(/[a-zA-Z]/, '')
        str_end = items[1].gsub(/[a-zA-Z]/, '')
        begin
          (Integer(str_start)..Integer(str_end)).each do |c_item|
            @our_refs<<"#{str_prefix}#{c_item}"
          end
        rescue ArgumentError
          @our_refs_invalid<<"#{str_prefix}#{str_start}"
          @our_refs_invalid<<"#{str_prefix}#{str_end}"
        end
      end
    end
  end

  def our_ref_present
    @our_ref_matters = []
    @matter_type = nil
    unless @our_refs_invalid.empty?
      @our_refs_invalid.each do |item|
        errors.add(:our_ref, "referenced matter #{item} not found")
      end
    end
    docs = VMatters.where(:registration_number => @our_refs)
    @our_refs.each do |ref|
      if docs.select{|doc| ref.eql?(doc.registration_number)}.empty?
        errors.add(:our_ref, "matter #{ref} not found!")
      end
    end
    docs.each do |doc|
        error = false
        if @matter_type.nil?
          @matter_type = doc.matter_type_id
        end
        if @matter_type != doc.matter_type_id
          errors.add(:our_ref, "references multiple matter types. Choose only one type!")
          error = true
        end
      unless error
        @our_ref_matters<<Matter.find(doc.id)
      end
    end
  end

  def not_future
    if invoice_date.future?
      errors.add(:invoice_date, 'may not be in future')
    end
    if !date_paid.nil? && date_paid.future?
      errors.add(:date_paid, 'may not be in future')
    end
  end

  def mark_as_paid
    if invoice_status.name.eql?('invoice.status.paid') && date_paid.nil?
      self.date_paid = Date.today
    end
  end

  def generate_registration_number
    Document.transaction do
      if invoice_type == 1
        foreign_number = Invoice.new_foreign_reg_number
        document.update_attribute(:registration_number, foreign_number)
      else
        local_number = Invoice.new_local_reg_number
        document.update_attribute(:registration_number, local_number)
      end
    end
  end

  def update_lines
    invoice_lines.each do |line|
      line.save
    end
  end

  def set_matter_type
    self.matter_type_id = @matter_type
  end

  def set_vat_rate
    self.billing_settings_id = BillingSetting.where(:active => true).first.id
  end

end
