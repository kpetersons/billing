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
  before_save :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      matter.document.update_attribute(:registration_number, "P#{id}")
    end
  end  
end
