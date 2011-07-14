# == Schema Information
#
# Table name: legals
#
#  id                   :integer(4)      not null, primary key
#  created_at           :datetime
#  updated_at           :datetime
#  matter_id            :integer(4)
#  opposed_marks        :string(255)
#  type                 :integer(4)
#  instance             :string(255)
#  opposite_party       :integer(4)
#  opposite_party_agent :integer(4)
#  date_of_closure      :date
#

class Legal < ActiveRecord::Base
  belongs_to :matter
  belongs_to :legal_type, :foreign_key => :type
  #
  after_create :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      unless matter.document.parent_document.nil?
        @reg_nr = "L#{id}"
        matter.document.update_attribute(:registration_number, @reg_nr)        
      end
    end
  end  
end
