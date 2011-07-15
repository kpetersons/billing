# == Schema Information
#
# Table name: patents
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  matter_id          :integer(4)
#  application_number :string(255)
#  application_date   :date
#  patent_number      :string(255)
#  patent_grant_date  :date
#  ep_appl_number     :string(255)
#  ep_number          :string(255)
#

class Patent < ActiveRecord::Base
  belongs_to :matter

  after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "P#{id}")
    end
  end
end
