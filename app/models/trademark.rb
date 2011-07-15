# == Schema Information
#
# Table name: trademarks
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer(4)
#  appl_date          :date
#  appl_number        :string(255)
#  notes              :string(255)
#  mark_name          :string(255)
#  cfe_index          :string(255)
#  application_date   :date
#  application_number :string(255)
#  priority_date      :date
#  ctm_number         :string(255)
#  wipo_number        :string(255)
#  reg_number         :string(255)
#

class Trademark < ActiveRecord::Base
  belongs_to :matter
  
  after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "M#{id}")
    end
  end  
end
