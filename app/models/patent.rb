# == Schema Information
#
# Table name: patents
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  matter_id  :integer(4)
#

class Patent < ActiveRecord::Base
  belongs_to :matter
  #
  after_create :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      unless matter.document.parent_document.nil?
        @reg_nr = "P#{id}"
        matter.document.update_attribute(:registration_number, @reg_nr)        
      end
    end
  end  
end
