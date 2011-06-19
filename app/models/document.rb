# == Schema Information
# Schema version: 20110609074500
#
# Table name: documents
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  registration_number :string(255)
#  description         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  parent_id           :integer(4)
#

class Document < ActiveRecord::Base

  belongs_to :user
  belongs_to :parent_document, :class_name => "Document", :foreign_key => "parent_id"
  #
  has_many :child_documents, :class_name => "Document", :foreign_key => "parent_id"
  has_many :document_tags
  has_many :tags, :through => :document_tags
  #
  has_one :matter
  #
  attr_accessible :registration_number, :description, :matter_attributes, :parent_id, :user_id
  accepts_nested_attributes_for :matter

  validates :registration_number, :presence=>true
  validates :user_id, :presence => true  

  def parent_document_registration_number
    (parent_document.nil?)? '' : parent_document.registration_number
  end

end
