# == Schema Information
#
# Table name: linked_matters
#
#  id               :integer         not null, primary key
#  matter_id        :integer
#  linked_matter_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class LinkedMatter < ActiveRecord::Base
  
  belongs_to :matter
  belongs_to :linked_matter, :class_name => "Matter", :foreign_key => :linked_matter_id

  attr_protected :linked_matter_registration_number  
 
  validates :matter_id, :presence => true
  validates :linked_matter_id, :presence => true

  validate :duplication

  private
  def duplication
    unless LinkedMatter.where(:matter_id => matter_id, :linked_matter_id => linked_matter_id).first.nil?
      errors.add(:matter_id, "Matters already linked")
    end
    unless LinkedMatter.where(:matter_id => linked_matter_id, :linked_matter_id => matter_id).first.nil?
      errors.add(:matter_id, "Matters already linked")
    end
    if matter_id == linked_patter_id
      errors.add(:matter_id, "Can not link matter with itself")
    end
  end

end
