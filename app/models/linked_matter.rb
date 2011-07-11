# == Schema Information
#
# Table name: linked_matters
#
#  id               :integer(4)      not null, primary key
#  matter_id        :integer(4)
#  linked_matter_id :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

class LinkedMatter < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :linked_matter, :class_name => "Matter", :foreign_key => :linked_matter_id

  attr_protected :linked_matter_registration_number  
 
  validates :matter_id, :presence => true
  validates :linked_matter_id, :presence => true
 
end
