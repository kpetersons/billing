# == Schema Information
#
# Table name: customs
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  matter_id  :integer(4)
#

class Custom < ActiveRecord::Base
  belongs_to :matter
  #
  after_create :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      @reg_nr = "B#{id}"
      unless matter.document.parent_document.nil?
        @reg_nr = "#{matter.document.parent_document.registration_number}/#{@reg_nr}"
      end
      matter.document.update_attribute(:registration_number, @reg_nr)
    end
  end
end
