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
#

class Matter < ActiveRecord::Base
  
  belongs_to  :document
  belongs_to  :applicant, :class_name => "Customer", :foreign_key => :applicant_id
  belongs_to  :agent, :class_name => "Customer", :foreign_key => :agent_id
  belongs_to  :author, :class_name => "User", :foreign_key => :author_id
  belongs_to  :matter_type
  belongs_to  :operating_party
  has_many    :matter_tasks
  has_many    :matter_clazzs
  has_many    :clazzs, :through => :matter_clazzs
  has_many    :invoice_matters
  has_many    :invoices, :through => :invoice_matters 
  
  has_one :trademark
  has_one :patent
  has_one :design
  has_one :legal
  has_one :custom
  
  validates :agent_id,            :presence => true
  validates :applicant_id,        :presence => true
  validates :matter_type_id,      :presence => true
  validates :operating_party_id,  :presence => true
  validates :author_id,  :presence => true  
  
  after_validation :prepare_ajax_fields  

  attr_protected :applicant_name, :agent_name, :classes
  
  after_create :generate_registration_number
  
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
  
  def tags
    document.tags
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
  
end
