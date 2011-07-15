# == Schema Information
#
# Table name: designs
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer(4)
#  application_number :string(255)
#  application_date   :date
#  design_number      :string(255)
#  rdc_appl_number    :string(255)
#  rdc_number         :string(255)
#

class Design < ActiveRecord::Base
  belongs_to :matter

  after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "D#{id}")
    end
  end
end