# == Schema Information
#
# Table name: matters
#
#  id                 :integer         not null, primary key
#  document_id        :integer
#  comment            :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  applicant_id       :integer
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  ir_number          :string(255)
#  mark_name          :string(255)
#  appl_date          :date
#  appl_number        :string(255)
#  agent_id           :integer
#  author_id          :integer
#  matter_type_id     :integer
#  operating_party_id :integer
#  matter_status_id   :integer
#  version            :integer         default(1)
#  orig_id            :integer
#  date_effective     :date            default(Sat, 03 Dec 2011)
#  date_effective_end :datetime
#

class Matter < ActiveRecord::Base


  belongs_to :document
  belongs_to :applicant, :class_name => "Customer", :foreign_key => :applicant_id, :primary_key => :orig_id
  belongs_to :agent, :class_name => "Customer", :foreign_key => :agent_id, :primary_key => :orig_id
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  belongs_to :matter_type
  belongs_to :operating_party
  belongs_to :matter_status
  has_many :matter_tasks
  has_many :invoice_matters
  has_many :invoices, :through => :invoice_matters

  has_many :linked_matters
  has_many :matters, :through => :linked_matters

  has_many :inverse_linked_matters, :class_name => "LinkedMatter", :foreign_key => :linked_matter_id
  has_many :inverse_matters, :through => :inverse_linked_matters, :source => :matter

  has_many :matter_images
  has_many :matter_clazzs
  has_many :clazzs, :through => :matter_clazzs

  has_one :trademark
  has_one :patent
  has_one :design
  has_one :legal
  has_one :custom
  has_one :patent_search
  has_one :search
  has_one :domain

  validates :agent_id, :presence => true
  validates :applicant_id, :presence => true, :if => :not_search
  validates :matter_type_id, :presence => true
  validates :operating_party_id, :presence => true
  validates :author_id, :presence => true

  after_validation :prepare_ajax_fields
  after_save :ensure_orig_id

  accepts_nested_attributes_for :trademark, :patent, :design, :legal, :custom, :linked_matters, :matter_images, :patent_search, :search, :domain
  attr_protected :applicant_name, :agent_name, :classes, :prefix

  def classes
    clazzs.all.collect { |c| "#{c.code}" }*","
  end

  def number
    document.registration_number
  end

  def linked
    LinkedMatter.where("matter_id = ? or linked_matter_id = ?", id, id)
  end

  def agent_name
    (agent.nil?) ? '' : agent.name
  end

  def applicant_name
    (applicant.nil?) ? '' : applicant.name
  end

  def sub_matters
    VMatters.where(:parent_id => document.id)
  end

  def parent_matter
    doc = self.document
    unless doc
      ObjectSpace.each_object(Document) {|o| doc = o if o.matter == self }
    end
    unless doc.parent_id.nil?
      return Matter.find_by_document_id(doc.parent_id)
    end
  end

  def status_name
    matter_status.name unless matter_status.nil?
  end

  def notes
    document.notes
  end

  def tags
    document.tags
  end

  def all_linked parent
    linked
  end

  def available_statuses
    MatterStatus.where("id != ?", matter_status_id).all
  end

  def has_invoices?
    if invoices.empty?
      return false;
    end
    if invoices.where(:invoice_status_id => InvoiceStatus.find_by_name('invoice.status.canceled').id).first.nil?
      return false;
    end
    return true;
  end

  def full_reg_nr_for_invoice
    if document.parent_id.nil?
      return document.registration_number
    end
    "#{document.parent_document.registration_number}/#{document.registration_number}"
  end

  def save_classes params
    mc = params[:document][:matter_attributes][:classes]
    unless mc.nil?
      matter_clazzs.delete_all
      mc.split(',').each do |name|
        clazz = Clazz.find_by_code(name)
        unless clazz.nil?
          if MatterClazz.where(:matter_id => id, :clazz_id => clazz.id).first.nil?
            matter_clazzs<<MatterClazz.new(:clazz_id => clazz.id, :matter_id => id)
          end
        end
      end
    end
  end

  def get_matter_count type
    return Matter.joins(:document).where(:documents => {:parent_id => nil}).where(:matter_type_id => type).count
  end

  def get_matter_count_per_year type, year
    return PatentSearch.joins(:matter => :document).where(:documents => {:parent_id => nil}).where("to_char(date_of_order, 'YYYY') = ?", year).count
  end

  def generate_registration_number
    unless matter_prefixes[matter_type_id].length > 1
      document.update_attribute(:registration_number, "#{matter_prefixes[matter_type_id]}#{get_matter_count (matter_type_id)}") and return
    end
    document.update_attribute(:registration_number, "#{matter_prefixes[matter_type_id]}#{get_matter_count_per_year(matter_type_id, patent_search.date_of_order.strftime('%Y'))}#{patent_search.date_of_order.strftime('%y')}")
  end

  def create_customers_history
    agent = MatterCustomer.new({:customer_id => agent_id, :matter_id => id, :customer_type => 'Agent', :takeover_date => DateTime.now, :author_id => author_id})
    applicant = MatterCustomer.new({:customer_id => applicant_id, :matter_id => id, :customer_type => 'Applicant', :takeover_date => DateTime.now, :author_id => author_id})
    agent.save! unless agent.nil?
    applicant.save! unless applicant.nil?
    custom = Custom.find_by_matter_id(id)
    unless custom.nil?
      custom.create_customers_history
    end
    legal = Legal.find_by_matter_id(id)
    unless legal.nil?
      legal.create_customers_history
    end

  end

  def change_customers_from_history matter_customer
    if matter_customer.customer_type.eql? "Agent"
      update_attribute(:agent_id, matter_customer.customer.id)
    end
    if matter_customer.customer_type.eql? "Applicant"
      update_attribute(:applicant_id, matter_customer.customer.id)
    end
    custom.change_customers_from_history matter_customer unless custom.nil?
    legal.change_customers_from_history matter_customer unless legal.nil?
  end

  def current_customer matter_customer
    if matter_customer.customer_type.eql?("Agent") && agent_id == matter_customer.customer_id
      return true
    end
    if matter_customer.customer_type.eql?("Applicant") && applicant_id == matter_customer.customer_id
      return true
    end
    return custom.current_customer matter_customer unless custom.nil?
    return legal.current_customer matter_customer unless legal.nil?
    return false
  end

  private
  def matter_prefixes
    return {
        1 => 'M',
        2 => 'P',
        3 => 'L',
        4 => 'D',
        5 => 'B',
        6 => 'PS',
        7 => 'S',
        8 => 'N'
    }
  end


  def prepare_ajax_fields
    unless errors[:agent_id].empty?
      errors[:agent_name] = Array.new(errors[:agent_id])
      errors[:agent_id].clear
    end
    unless errors[:applicant_id].empty?
      errors[:applicant_name] = Array.new(errors[:applicant_id])
      errors[:applicant_id].clear
    end
  end

  def not_search
    if  patent_search.nil? && search.nil?
      return true
    end
    return false
  end

  def ensure_orig_id
    if self.orig_id.nil?
      update_attribute(:orig_id, self.id)
    end
  end
end
