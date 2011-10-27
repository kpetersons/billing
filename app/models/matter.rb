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
#

class Matter < ActiveRecord::Base


  belongs_to :document
  belongs_to :applicant, :class_name => "Customer", :foreign_key => :applicant_id
  belongs_to :agent, :class_name => "Customer", :foreign_key => :agent_id
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  belongs_to :matter_type
  belongs_to :operating_party
  belongs_to :matter_status
  has_many :matter_tasks
  has_many :invoice_matters
  has_many :invoices, :through => :invoice_matters
  has_many :linked_matters, :class_name => "LinkedMatter", :foreign_key => :matter_id
  has_many :matters, :through => :linked_matters
  has_many :linked, :class_name => "Matter", :finder_sql => 'select distinct m.* from matters m join linked_matters lm on ((m.id = lm.matter_id and lm.linked_matter_id = #{id}) or (m.id = lm.linked_matter_id and lm.matter_id = #{id}))'
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

  accepts_nested_attributes_for :trademark, :patent, :design, :legal, :custom, :linked_matters, :matter_images, :patent_search, :search, :domain
  attr_protected :applicant_name, :agent_name, :classes, :prefix

  def classes
    clazzs.all.collect { |c| "#{c.code}" }*","
  end

  #start column filter
  def ind_agent
    agent.name
  end

  def ind_applicant
    applicant.name
  end

  def ind_matter_type
    I18n.t matter_type.name
  end

  def ind_operating_party
    I18n.t operating_party.name
  end

  def ind_matter_status
    I18n.t status_name
  end

  def ind_created_at
    created_at.to_s(:show)
  end

  def ind_updated_at
    updated_at.to_s(:show)
  end

  def ind_author
    author.individual.name
  end

  def ind_application_date
    unless trademark.nil?
      return trademark.appl_date.to_s(:show) unless trademark.appl_date.nil?
    end
    unless patent.nil?
      return patent.application_date.to_s(:show) unless patent.application_date.nil?
    end
    unless design.nil?
      return design.application_date.to_s(:show) unless design.application_date.nil?
    end
  end

  def ind_application_number
    unless trademark.nil?
      return trademark.appl_number
    end
    unless patent.nil?
      return patent.application_number
    end
    unless design.nil?
      return design.application_number
    end
  end

  def ind_notes
    unless trademark.nil?
      trademark.notes
    end
  end

  def ind_mark_name
    unless trademark.nil?
      trademark.mark_name
    end
  end

  def ind_cfe_index
    unless trademark.nil?
      trademark.cfe_index
    end
  end

  def ind_priority_date
    unless trademark.nil?
      trademark.priority_date.to_s(:show) unless trademark.priority_date.nil?
    end
  end

  def ind_ctm_number
    unless trademark.nil?
      trademark.ctm_number
    end
  end

  def ind_wipo_number
    unless trademark.nil?
      trademark.wipo_number
    end
  end

  def ind_reg_number
    unless trademark.nil?
      trademark.reg_number
    end
  end

  def ind_patent_number
    unless patent.nil?
      patent.patent_number
    end
  end

  def ind_patent_grant_date
    unless patent.nil?
      patent.patent_grant_date.to_s(:show) unless patent.patent_grant_date.nil?
    end
  end

  def ind_ep_appl_number
    unless patent.nil?
      patent.ep_appl_number
    end
  end

  def ind_ep_number
    unless patent.nil?
      patent.ep_number
    end
  end

  def ind_design_number
    unless design.nil?
      design.design_number
    end
  end

  def ind_rdc_appl_number
    unless design.nil?
      design.rdc_appl_number
    end
  end

  def ind_rdc_number
    unless design.nil?
      design.rdc_number
    end
  end

  def ind_opposed_marks
    unless legal.nil?
      legal.opposed_marks
    end
  end

  def ind_instance
    unless legal.nil?
      legal.instance
    end
  end

  def ind_date_of_closure
    unless legal.nil?
      legal.date_of_closure.to_s(:show) unless legal.date_of_closure.nil?
    end
  end

  def ind_opposite_party
    unless legal.nil?
      legal.opposite_party.name unless legal.opposite_party.nil?
    end
  end

  def ind_opposite_party_agent
    unless legal.nil?
      legal.opposite_party_agent.name unless legal.opposite_party_agent.nil?
    end
  end

  def ind_legal_type
    unless legal.nil?
      legal.legal_type.name unless legal.legal_type.nil?
    end
  end

  def ind_date_of_order_alert
    unless custom.nil?
      custom.date_of_order_alert.to_s(:show) unless custom.date_of_order_alert.nil?
    end
  end

  def ind_ca_application_date
    unless custom.nil?
      custom.ca_application_date.to_s(:show) unless custom.ca_application_date.nil?
    end
  end

  def ind_ca_application_number
    unless custom.nil?
      custom.ca_application_number
    end
  end

  def ind_client_all_ip
    unless custom.nil?
      custom.client_all_ip.name unless custom.client_all_ip.nil?
    end
  end

  def ind_description
    unless patent_search.nil?
      patent_search.description
    end
  end

  def ind_patent_eq_numbers
    unless patent_search.nil?
      patent_search.patent_eq_numbers
    end
  end

  def ind_no_of_patents
    unless patent_search.nil?
      patent_search.no_of_patents
    end
  end

  def ind_search_for
    unless search.nil?
      search.search_for
    end
  end

  def ind_no_of_objects
    unless search.nil?
      search.no_of_objects
    end
  end

  def ind_express_search
    unless search.nil?
      search.express_search?
    end
  end

  def ind_date_of_order
    unless patent_search.nil?
      return patent_search.date_of_order.to_s(:show) unless patent_search.date_of_order.nil?
    end
    unless search.nil?
      return search.date_of_order.to_s(:show) unless search.date_of_order.nil?
    end
  end

  #end column filter
  def number
    document.registration_number
  end

  def classes
    clazzs.collect { |clazz| clazz.code }.join(',')
  end

  def agent_name
    (agent.nil?) ? '' : agent.name
  end

  def applicant_name
    (applicant.nil?) ? '' : applicant.name
  end

  def sub_matters
    Matter.where(:document_id => document.child_documents)
  end

  def has_parent
    (document.parent_document.nil?) ? false : true
  end

  def parent_matter
    if has_parent
      Matter.find_by_document_id(document.parent_document.id)
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
    MatterStatus.where("id != ?", [matter_status_id]).all
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

  private
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
end
