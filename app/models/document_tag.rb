# == Schema Information
# Schema version: 20110613110722
#
# Table name: document_tags
#
#  id          :integer(4)      not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  document_id :integer(4)
#  tag_id      :integer(4)
#

class DocumentTag < ActiveRecord::Base
  belongs_to :document
  belongs_to :tag  
end
