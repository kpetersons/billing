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
#  client_all_ip         :integer(4)
#

class Custom < ActiveRecord::Base
  belongs_to :matter
  #
  after_create :generate_registration_number

  private
  def generate_registration_number
    Document.transaction do
      unless matter.document.parent_document.nil?
        @reg_nr = "B#{id}"
        matter.document.update_attribute(:registration_number, @reg_nr)        
      end
    end
  end
end
