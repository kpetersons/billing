# == Schema Information
#
# Table name: patents
#
#  id                 :integer         not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer
#  application_number :string(255)
#  application_date   :date
#  patent_number      :string(255)
#  patent_grant_date  :date
#  ep_appl_number     :string(255)
#  ep_number          :integer
#  registration_date  :date
#

class Patent < ActiveRecord::Base
  belongs_to :matter
  validates :ep_number, :numericality => true

  validates :application_date, :date_not_far_future => :true
  validates :patent_grant_date, :date_not_far_future => :true
  validates :registration_date, :date_not_far_future => :true

  #after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "P#{matter.orig_id}")
    end
  end
end
