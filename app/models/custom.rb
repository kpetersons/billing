# == Schema Information
#
# Table name: customs
#
#  id                    :integer         not null, primary key
#  created_at            :datetime
#  updated_at            :datetime
#  matter_id             :integer
#  date_of_order_alert   :date
#  ca_application_date   :date
#  ca_application_number :string(255)
#  client_all_ip_id      :integer
#  vid_ref               :text
#

class Custom < ActiveRecord::Base
  belongs_to :matter
  belongs_to :client_all_ip, :class_name => 'Customer', :foreign_key => :client_all_ip_id
  
  validates :date_of_order_alert, :date_not_far_future => true
  validates :ca_application_date, :date_not_far_future => true

  attr_accessor :client_all_ip_name
  
  def client_all_ip_name
    client_all_ip.name unless client_all_ip.nil?
  end

end
