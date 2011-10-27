# == Schema Information
#
# Table name: document_tags
#
#  id          :integer         not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  document_id :integer
#  tag_id      :integer
#

class DocumentTag < ActiveRecord::Base
  belongs_to :document
  belongs_to :tag  
end
