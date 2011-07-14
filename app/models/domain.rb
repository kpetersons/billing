# == Schema Information
#
# Table name: domains
#
#  id                :integer(4)      not null, primary key
#  matter_id         :integer(4)
#  domain_name       :string(255)
#  registration_date :date
#  created_at        :datetime
#  updated_at        :datetime
#

class Domain < ActiveRecord::Base
  belongs_to :matter
  
  after_create :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      unless matter.document.parent_document.nil?
        @reg_nr = "DO#{id}"
        matter.document.update_attribute(:registration_number, @reg_nr)        
      end
    end
  end  
end
