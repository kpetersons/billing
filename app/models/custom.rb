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


  def create_customers_history
    client_all_ip = MatterCustomer.new({:customer_id => client_all_ip_id, :matter_id => matter_id, :customer_type => 'client_all_ip'.capitalize, :takeover_date => DateTime.now, :author_id => matter.author_id})
    client_all_ip.save!
  end

  def change_customers_from_history matter_customer
    if matter_customer.customer_type.eql?("Client_all_ip")
      update_attribute(:client_all_ip_id, matter_customer.customer.id)
    end
  end

  def current_customer matter_customer
    if matter_customer.customer_type.eql?("Client_all_ip") && client_all_ip_id == matter_customer.customer_id
      return true
    end
    return false
  end
end
