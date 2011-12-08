# == Schema Information
#
# Table name: legals
#
#  id                      :integer         not null, primary key
#  created_at              :datetime
#  updated_at              :datetime
#  matter_id               :integer
#  opposed_marks           :string(255)
#  instance                :string(255)
#  date_of_closure         :date
#  opposite_party_id       :integer
#  opposite_party_agent_id :integer
#  legal_type_id           :integer
#  date_of_order           :date
#  court_ref               :text
#

class Legal < ActiveRecord::Base

  belongs_to :matter
  belongs_to :legal_type
  belongs_to :opposite_party, :class_name => 'Customer', :foreign_key => :opposite_party_id
  belongs_to :opposite_party_agent, :class_name => 'Customer', :foreign_key => :opposite_party_agent_id
  
  attr_accessor :opposite_party_name, :opposite_party_agent_name

  validates :date_of_closure, :date_not_far_future => true
  validates :date_of_order, :date_not_far_future => true

  def opposite_party_name
    opposite_party.name unless opposite_party.nil?
  end
  
  def opposite_party_agent_name
    opposite_party_agent.name unless opposite_party_agent.nil?
  end  

end
