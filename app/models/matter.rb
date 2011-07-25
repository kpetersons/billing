# == Schema Information
#
# Table name: matters
#
#  id                 :integer(4)      not null, primary key
#  document_id        :integer(4)
#  comment            :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  applicant_id       :integer(4)
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  ir_number          :string(255)
#  mark_name          :string(255)
#  appl_date          :date
#  appl_number        :string(255)
#  agent_id           :integer(4)
#  author_id          :integer(4)
#  matter_type_id     :integer(4)
#  operating_party_id :integer(4)
#  matter_status_id   :integer(4)
#

class Matter < ActiveRecord::Base
  

  
  belongs_to  :document
  belongs_to  :applicant, :class_name => "Customer", :foreign_key => :applicant_id
  belongs_to  :agent, :class_name => "Customer", :foreign_key => :agent_id
  belongs_to  :author, :class_name => "User", :foreign_key => :author_id
  belongs_to  :matter_type
  belongs_to  :operating_party
  belongs_to  :matter_status
  has_many    :matter_tasks
  has_many    :invoice_matters
  has_many    :invoices, :through => :invoice_matters 
  has_many    :linked_matters, :class_name => "LinkedMatter", :foreign_key => :matter_id
  has_many    :matters, :through => :linked_matters
  has_many    :linked, :class_name => "Matter", :finder_sql => 'select distinct m.* from matters m join linked_matters lm on ((m.id = lm.matter_id and lm.linked_matter_id = #{id}) or (m.id = lm.linked_matter_id and lm.matter_id = #{id}))'  
  has_many    :matter_images
  
  has_one :trademark
  has_one :patent
  has_one :design
  has_one :legal
  has_one :custom
  has_one :patent_search
  has_one :search
  has_one :domain
  
  validates :agent_id,            :presence => true
  validates :applicant_id,        :presence => true, :if => :not_search
  validates :matter_type_id,      :presence => true
  validates :operating_party_id,  :presence => true
  validates :author_id,  :presence => true  
  
  after_validation :prepare_ajax_fields  
  
  accepts_nested_attributes_for :trademark, :patent, :design, :legal, :custom, :linked_matters, :matter_images, :patent_search, :search, :domain
  attr_protected :applicant_name, :agent_name, :classes, :prefix
  
  def number
    document.registration_number
  end
  
  def classes
    clazzs.collect {|clazz| clazz.code}.join(',')
  end
  
  def agent_name
    (agent.nil?)? '' : agent.name
  end

  def applicant_name
    (applicant.nil?)? '' : applicant.name
  end
  
  def sub_matters
    Matter.where(:document_id => document.child_documents)
  end

  def has_parent
    (document.parent_document.nil?)? false : true
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
