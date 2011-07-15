# == Schema Information
#
# Table name: customs
#
#  id                    :integer(4)      not null, primary key
#  created_at            :datetime
#  updated_at            :datetime
#  matter_id             :integer(4)
#  date_of_order_alert   :date
#  ca_application_date   :date
#  ca_application_number :string(255)
#  client_all_ip_id      :integer(4)
#

class Custom < ActiveRecord::Base
  belongs_to :matter
  
  after_create :generate_registration_number
  
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.registration_number = "B#{id}"
    end
  end
end
