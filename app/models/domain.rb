# == Schema Information
#
# Table name: domains
#
#  id                :integer(4)      not null, primary key
#  matter_id         :integer(4)
#  domain_name       :string(255)
#  registration_date :date
#  created_at        :datetime
#  updated_at        :datetime
#

class Domain < ActiveRecord::Base
  belongs_to :matter
  after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "N#{id}")
    end
  end
end