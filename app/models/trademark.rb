# == Schema Information
#
# Table name: trademarks
#
#  id                 :integer         not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
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
#  registration_date  :date
#

#== Schema Information
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

  validates :mark_name, :presence => true, :length => {:within => 1..250}

  validates :appl_date, :date_not_far_future => true
  validates :application_date, :date_not_far_future => true
  validates :priority_date, :date_not_far_future => true
  validates :registration_date, :date_not_far_future => true

  before_save :replace_spaces
  before_update :replace_spaces

  attr_protected :classes

  def replace_spaces
    ctm_number.gsub!(/ /, "")
    reg_number.gsub!(/ /, "")
    wipo_number.gsub!(/ /, "")
  end

  #after_create :generate_registration_number

  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "M#{matter.orig_id}")
    end
  end
end
