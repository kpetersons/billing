# == Schema Information
#
# Table name: searches
#
#  id             :integer(4)      not null, primary key
#  matter_id      :integer(4)
#  search_for     :string(255)
#  no_of_objects  :integer(1)
#  express_search :boolean(1)
#  date_of_order  :date
#  created_at     :datetime
#  updated_at     :datetime
#

class Search < ActiveRecord::Base
  belongs_to :matter
  
  after_create :generate_registration_number
  def generate_registration_number
    if matter.document.parent_id.nil?
      matter.document.update_attribute(:registration_number, "S#{id}")
    end
  end  
end
