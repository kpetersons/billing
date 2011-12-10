# == Schema Information
#
# Table name: matter_customers
#
#  id            :integer         not null, primary key
#  matter_id     :integer
#  customer_id   :integer
#  takeover_date :date
#  shortnote     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  author_id     :integer
#  customer_type :string(255)
#

class MatterCustomer < ActiveRecord::Base
  belongs_to :customer
  belongs_to :matter
  belongs_to :author, :class_name => "User"

  attr_accessible :customer_type, :shortnote, :takeover_date, :customer_id, :matter_id

  validates :matter_id, :presence => true
  validates :customer_id, :presence => true
  validates :takeover_date, :presence => true
  validates :customer_type, :presence => true
  validates :author_id, :presence => true

  attr_protected :customer_name

  def customer_types
    [:agent, :applicant, :customer_all_ip, :opposite_party_agent, :opposite_party_applicant]
  end

  def customer_name
    customer.name unless customer.nil?
  end

end
