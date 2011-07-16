# == Schema Information
#
# Table name: legals
#
#  id                      :integer(4)      not null, primary key
#  created_at              :datetime
#  updated_at              :datetime
#  matter_id               :integer(4)
#  opposed_marks           :string(255)
#  instance                :string(255)
#  date_of_closure         :date
#  oposing_party_id        :integer(4)
#  oposing_party_agent_id  :integer(4)
#  opposite_party_id       :integer(4)
#  opposite_party_agent_id :integer(4)
#  legal_type_id           :integer(4)
#

class Legal < ActiveRecord::Base

  belongs_to :matter
  belongs_to :legal_type
  belongs_to :opposite_party, :class_name => 'Customer', :foreign_key => :opposite_party_id
  belongs_to :opposite_party_agent, :class_name => 'Customer', :foreign_key => :opposite_party_agent_id
  
  attr_accessor :opposite_party_name, :opposite_party_agent_name
  
  def opposite_party_name
    opposite_party.name unless opposite_party.nil?
  end
  
  def opposite_party_agent_name
    opposite_party_agent.name unless opposite_party_agent.nil?
  end  
  
  after_create :generate_registration_number
  
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "L#{id}")
    end
  end  
end
