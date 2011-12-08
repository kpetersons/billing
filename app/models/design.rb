# == Schema Information
#
# Table name: designs
#
#  id                 :integer         not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  application_number :string(255)
#  application_date   :date
#  design_number      :string(255)
#  rdc_appl_number    :string(255)
#  rdc_number         :string(255)
#  registration_date  :date
#

class Design < ActiveRecord::Base
  belongs_to :matter

  validates :design_number, :numericality => true
  validates :application_date, :date_not_far_future => true
  validates :registration_date, :date_not_far_future => true

  #after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "D#{matter.orig_id}")
    end
  end
end
