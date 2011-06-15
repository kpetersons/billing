# == Schema Information
# Schema version: 20110612110454
#
# Table name: tags
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  has_many :document_tags
  has_many :documents, :through => :document_tags
  
  validates :name, :presence => true
end
