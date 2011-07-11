# == Schema Information
#
# Table name: customs
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  matter_id  :string(255)
#

class Custom < ActiveRecord::Base
  belongs_to :matter
  #
  after_create :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      matter.document.update_attribute(:registration_number, "B#{id}")
    end
  end
end
